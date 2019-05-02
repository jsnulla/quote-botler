'use strict'
const AWS = require('aws-sdk')
const comprehend = new AWS.Comprehend({ apiVersion: '2017-11-27' });
const fetch = require('node-fetch')
const Twitter = require('twitter')
const client = new Twitter({
  consumer_key: process.env.twitter_consumer_key,
  consumer_secret: process.env.twitter_consumer_secret,
  access_token_key: process.env.twitter_access_key,
  access_token_secret: process.env.twitter_access_secret,
})

module.exports.tweetQuote = async (event, context) => {
  client.get('account/verify_credentials.json', (error, data, response) => {
    if (error) {
      console.log('ERROR - could not verify account', error)
    } else {
      console.log('VERIFICATION DATA', data, response)
    }
  })

  let validQuotes = []
  for (let i = 0; i < 15; i++) {
    await fetch('https://favqs.com/api/qotd', { method: 'get' })
      .then(response => response.json())
      .then((response) => {
        const isQuoteValid = checkQuoteValidity(response.quote)
        if (isQuoteValid) {
          const params = {
            LanguageCode: 'en',
            Text: response.quote.body
          };

          comprehend.detectSentiment(params, (err, data) => {
            if (err) {
              console.log('COMPREHEND ERROR', err)
            } else {
              console.log('COMPREHEND RESULTS', data)
              response.quote.comprehend = data
              validQuotes.push(response.quote)
            }
          });
        }
      })
  }
  console.log('validQuotes', validQuotes)

  const positiveQuotes = await validQuotes.filter(quote => quoteIsPositive(quote))
  console.log('POSITIVE QUOTES', positiveQuotes)

  const slightlyPositiveQuotes = await validQuotes.filter(quote => quoteIsSlightlyPositive(quote))
  console.log('SLIGHTLY POSITIVE QUOTES', slightlyPositiveQuotes)

  let chosenQuote = null
  if (positiveQuotes.length > 0) {
    chosenQuote = positiveQuotes[Math.floor(Math.random() * Math.floor(positiveQuotes.length))]
  } else if (slightlyPositiveQuotes.length > 0) {
    chosenQuote = positiveQuotes[Math.floor(Math.random() * Math.floor(slightlyPositiveQuotes.length))]
  }

  if (chosenQuote) {
    console.log('chosen quote', chosenQuote)
    const params = {
      status: `"${chosenQuote.body}" - ${chosenQuote.author}\r\n\r\n- JayBot`
    }

    await client.post('statuses/update', params)
      .then((data, response) => {
        console.log('tweeting quote successful', data, response)
        return { message: 'BOTler tweeted something inspirational! ^_^', event }
      })
      .catch((error) => {
        console.log('tweet failed', error)
        return { message: 'BOTler failed to post a tweet X_X', event }
      })
  } else {
    console.log('no positive quotes at this time T_T')
  }
}

function quoteIsPositive(quote) {
  return quote.comprehend.Sentiment == "POSITIVE"
}

function quoteIsSlightlyPositive(quote) {
  return quote.comprehend.Sentiment == "NEUTRAL" && quote.comprehend.SentimentScore.Positive >= 0.2
}

function checkQuoteValidity(quote) {
  console.log('quote to check', quote)
  if ((quote.body.length + quote.author.length + 20) <= 280) {
    if (quote.downvotes_count < 1) {
      return true
    }
  } else {
    return false
  }
}
