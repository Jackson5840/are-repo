var serverbase = 'https://neuromorpho.org/ingestapi/';
function processTweetLink() {
        // obtain link
        const tweet_link = document.getElementById('tweet_link').value;

        console.log("User input: " + tweet_link)
        // send to server
        fetch(serverbase + '/create_tweet', {
            method: 'POST',
            body: JSON.stringify({ tweet_link }),
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (response.ok) {
                console.log('Tweet created successfully.');
                alert('Tweet Article (fixed) created successfully.');
            } else {
                console.error('Error creating tweet.');
                alert('Error creating tweet.');
            }
        })
        .catch(error => {
            console.error('An error occurred:', error);
            alert('An error occurred: ' + error);
        });
    }

function processTweetLinks() {
        // obtain link
        const tweet_links = document.getElementById('tweet_links').value;

        console.log("User input: " + tweet_links)
        // send to server
        fetch(serverbase + '/create_tweets', {
            method: 'POST',
            body: JSON.stringify({ tweet_links }),
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (response.ok) {
                console.log('Tweet created successfully.');
                alert('Tweet Article (new customize) created successfully.');
            } else {
                console.error('Error creating tweet.');
                alert('Error creating tweet.');
            }
        })
        .catch(error => {
            console.error('An error occurred:', error);
            alert('An error occurred: ' + error);
        });
    }

function processTweetLinkCustomize(){

        // obtain link
        const tweet_link_customize = document.getElementById('tweet_link_customize').value;

        console.log("User input: " + tweet_link_customize)
        // send to server
        fetch(serverbase + '/create_tweetc_customize', {
            method: 'POST',
            body: JSON.stringify({ tweet_link_customize }),
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (response.ok) {
                console.log('Tweet created successfully.');
                alert('Tweet Article (customize) created successfully.');
            } else {
                console.error('Error creating tweet.');
                alert('Error creating tweet.');
            }
        })
        .catch(error => {
            console.error('An error occurred:', error);
            alert('An error occurred: ' + error);
        });
    }