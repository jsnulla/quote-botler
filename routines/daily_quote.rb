require './lib/boot'

def perform(event:, context:)
  success_message = 'Tweeted inspirational shit to everybody 💒'

  retries = 0
  begin
    quotes = fetch_quotes()
    potential_quotes = analyze_quotes(quotes)
    chosen_quote = potential_quotes.sample
    quote_data = {
      sentiment: chosen_quote[:sentiment],
      sentiment_score: chosen_quote[:sentiment_score]
    }

    tweet = Tweet.create(message: chosen_quote[:message], data: quote_data)
    tweet.post
  rescue => e
    retries += 1

    if retries <= 3
      sleep_time = retries * 10
      puts "😱 This is embarassing.. I failed because: #{e.message}"
      puts "I will retry for the #{retries.ordinalize} time after #{sleep_time} seconds 🙏"
      sleep sleep_time
      retry
    end
    puts 'I could not give everybody an inspiration today 😢'
    raise e
  end

  {
    statusCode: 200,
    body: success_message
  }
end

def fetch_quotes
  headers = { 'Authorization' => "Token token=#{ENV['FAVQS_API_KEY']}" }
  query = {
    filter: ['peace', 'love', 'inspirational'].sample,
    type: 'tag'
  }

  results = HTTParty.get('https://favqs.com/api/quotes', query: query, headers: headers)
  return results['quotes'].map{|quote| {author: quote['author'], message: quote['body']}}
end

def analyze_quotes(quotes)
  sentiment_analysis_results = App::Client.Comprehend.batch_detect_sentiment({
    text_list: quotes.map{|quote| quote[:message]},
    language_code: 'en'
  }).result_list

  quotes_with_scores = quotes.each_with_index.map{ |quote, index|
    analysis = sentiment_analysis_results[index].to_hash
    quote[:sentiment] = analysis[:sentiment]
    quote[:sentiment_score] = analysis[:sentiment_score]
    quote
  }
  # no negative vibes
  quotes_with_scores.select!{ |quote| quote[:sentiment] != 'NEGATIVE' }
  # no bad words
  bad_words_regex = /death|dying|suicide|kill|polygamy|gay|faggot|fag/
  quotes_with_scores.select!{ |quote| (quote[:message] =~ bad_words_regex).nil? }
  # nothing slightly negative
  quotes_with_scores.select!{ |quote| quote[:sentiment_score][:negative] < 0.25 }
  # nothing only slightly positive
  quotes_with_scores.select!{ |quote| quote[:sentiment_score][:positive] > 0.40 }

  puts 'These were the potential quotes:'
  quotes_with_scores.each{ |quote| pp quote }

  return quotes_with_scores
end
