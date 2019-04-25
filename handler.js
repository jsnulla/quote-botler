'use strict'
const fetch = require('node-fetch')
const Twitter = require('twitter')

module.exports.tweetQuote = async (event, context) => {
  const chosenQuote = await fetch('https://favqs.com/api/qotd', { method: 'get' })
    .then(response => response.json())
    .then((response) => {
      const isQuoteValid = checkQuoteValidity(response.quote)
      console.log('quote fetched', response)
      console.log('quote is valid?', isQuoteValid)

      return isQuoteValid ? response.quote : false
    })

  if (chosenQuote == false) {
    console.log('chosen quote was not valid :(')
  } else {
    console.log('chosen quote', chosenQuote)
    const params = {
      status: `"${chosenQuote.body}" - ${chosenQuote.author}\r\n\r\n- JayBot`
    }

    const client = await new Twitter({
      consumer_key: process.env.twitter_consumer_key,
      consumer_secret: process.env.twitter_consumer_secret,
      access_token_key: process.env.twitter_access_key,
      access_token_secret: process.env.twitter_access_secret,
    })

    await client.post('statuses/update', params, (error, data, response) => {
      if (error) {
        console.log('tweet failed', error)
      } else {
        console.log('tweeting quote successful', data, response)
      }
    })

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Go Serverless v1.0! Your function executed successfully!',
        input: event,
      }),
    }
  }
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
