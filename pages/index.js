import React from 'react'

function HomePage() {
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
    .then(console.log)
  }
    
  return <>
  <button onClick={handleClick}>Request</button>
  <pre>{JSON.stringify(result, null, 2)}</pre>
  </>
}

export default HomePage