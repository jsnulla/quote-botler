'use strict'
const fetch = require('node-fetch')
const Twitter = require('twitter')

module.exports.getQuotes = async (event, context) => {
  const chosenQuote = await fetch('https://favqs.com/api/quotes/?filter=success&type=tag', {
    method: 'get',
    headers: new fetch.Headers({
      'Authorization': `Token token="${process.env.favqs_api_key}"`,
      'Content-Type': 'application/json'
    })
  })
    .then(response => response.json())
    .then((response) => {
      return chooseQuote(response.quotes)
    })

  const params = {
    status: `"${chosenQuote.quote.body}" - ${chosenQuote.quote.author}\r\nJayBot`
  }

  console.log('chosen quote', chosenQuote)

  const client = await new Twitter({
    consumer_key: process.env.twitter_consumer_key,
    consumer_secret: process.env.twitter_consumer_secret,
    access_token_key: process.env.twitter_access_key,
    access_token_secret: process.env.twitter_access_secret,
  })

  await client.post('statuses/update', params, (error, data, response) => {
    console.log('error', error)
    console.log('data', data)
    console.log('response', response)
  })

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Go Serverless v1.0! Your function executed successfully!',
      input: event,
    }),
  }

  function chooseQuote(quotes) {
    const candidates = quotes.map((quote) => {
      if ((quote.body.length + quote.author.length + 20) < 280) {
        return quote
      }
    })

    if (candidates.length > 0) {
      return {
        candidate: true,
        quote: candidates[Math.floor(Math.random() * Math.floor(candidates.length))]
      }
    } else {
      return {
        candidate: false,
        quote: quotes[Math.floor(Math.random() * Math.floor(quotes.length))]
      }
    }
  }

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event }
}
