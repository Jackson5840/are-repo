var serverbase = '../';

function submitThread(inputId, endpoint, fieldName, successMessage) {
    const input = document.getElementById(inputId);
    const content = input.value.trim();

    if (!content) {
        alert('Thread content is required.');
        return;
    }

    const payload = {};
    payload[fieldName] = content;

    fetch(serverbase + endpoint, {
        method: 'POST',
        body: JSON.stringify(payload),
        headers: {'Content-Type': 'application/json'}
    })
    .then(async response => {
        const result = await response.json().catch(() => ({}));
        if (!response.ok) {
            throw new Error(result.message || 'Unable to create Threads post.');
        }
        if (result.embed_status === 'failed') {
            const reason = result.embed_error || 'Unknown homepage embed error.';
            const postId = result.thread_id ? ' Post ID: ' + result.thread_id + '.' : '';
            alert(successMessage + ' Embedding failed: ' + reason + postId + ' Do not submit it again.');
        } else {
            alert(successMessage + ' Embeded successfully.');
        }
        input.value = '';
    })
    .catch(error => {
        console.error('Error creating Threads post:', error);
        alert(error.message);
    });
}

function processThreadLink() {
    submitThread(
        'thread_link',
        '/create_thread',
        'thread_link',
        'Threads post created successfully.'
    );
}

function processThreadText() {
    submitThread(
        'thread_text',
        '/create_threads',
        'thread_text',
        'Threads post created successfully.'
    );
}

function processThreadCustomize() {
    submitThread(
        'thread_text_customize',
        '/create_thread_customize',
        'thread_text_customize',
        'Threads post created successfully.'
    );
}
