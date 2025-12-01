// Módulo ES: exporta funções usadas pelo componente Blazor
export function unlockAudio(src) {
    try {
        // tenta usar elemento existente
        let audio = document.getElementById('alertSound');
        if (!audio) {
            audio = new Audio(src);
            audio.id = 'alertSound';
            audio.style.display = 'none';
            document.body.appendChild(audio);
        }

        // tentativa de play/pause para desbloquear áudio em clique do usuário
        const p = audio.play();
        if (p && typeof p.then === 'function') {
            p.then(() => {
                audio.pause();
                audio.currentTime = 0;
            }).catch(() => {
                // pode falhar em autoplay restrito — sem ação adicional
            });
        }
    } catch (e) {
        // falha silente: não queremos quebrar o fluxo do componente
    }
}

export function playAlert() {
    try {
        let audio = document.getElementById('alertSound');
        if (!audio && window._pomodoroAudio) {
            audio = window._pomodoroAudio;
        }
        if (!audio) {
            // fallback: tenta criar e tocar
            audio = new Audio('alertSound.wav');
            audio.id = 'alertSound';
            audio.style.display = 'none';
            document.body.appendChild(audio);
        }
        audio.currentTime = 0;
        audio.play().catch(() => { /* ignorar falhas de reprodução */ });
    } catch (e) {
        // ignora erros JS
    }
}

// Controla YouTube iframe via postMessage (requer enablejsapi=1 no src do iframe)
export function playYouTube(iframeId) {
    try {
        const iframe = document.getElementById(iframeId);
        if (!iframe) return;
        iframe.contentWindow.postMessage('{"event":"command","func":"playVideo","args":""}', '*');
    } catch (e) {
        // ignora erros JS
    }
}

export function pauseYouTube(iframeId) {
    try {
        const iframe = document.getElementById(iframeId);
        if (!iframe) return;
        iframe.contentWindow.postMessage('{"event":"command","func":"pauseVideo","args":""}', '*');
    } catch (e) {
        // ignora erros JS
    }
}