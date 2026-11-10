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
        alert(successMessage + (result.thread_id ? ' ID: ' + result.thread_id : ''));
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
        'Threads article (fixed) created successfully.'
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
        'Custom Threads post created successfully.'
    );
}
