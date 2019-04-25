'use strict'
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

    await client.post('statuses/update', params)
      .then((data, response) => {
        console.log('tweeting quote successful', data, response)
        return { message: 'BOTler tweeted something inspirational! ^_^', event }
      })
      .catch((error) => {
        console.log('tweet failed', error)
        return { message: 'BOTler failed to post a tweet X_X', event }
      })
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
