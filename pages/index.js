import React from 'react'
import Head from 'next/head'

function IndexPage() {
  const [ result, setResult ] = React.useState({})
  const handleClick = () => {
  fetch('https://api.tracker.yandex.net/v2/myself', {
    headers: {
      Authorization: 'OAuth AQAAAAA6-xOMAAd5NiluDTEGHEmRl6TfIdlzL2A',
      'X-Org-ID': '6610725',
      'Access-Control-Allow-Origin': '*'
    },
  })
    .then(res => res.json())
    .then(setResult)
  }
    
  return <>
    <Head>
      <title>Create Next App</title>
      <link rel="icon" href="/favicon.ico" />
    </Head>

    <button onClick={handleClick}>Request</button>
    <pre>{JSON.stringify(result, null, 2)}</pre>
  </>
}

export default IndexPage
