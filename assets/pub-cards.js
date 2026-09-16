// pub-cards.js
// Abstract / Citation / BibTeX toggles + copy button for publication cards.
// Used on project pages (event delegation, so timing/order doesn't matter).
(function () {
  function getCard(el) {
    while (el && !(el.classList && el.classList.contains('pub-card'))) el = el.parentNode;
    return el;
  }
  function showPanel(card, label, html, mode) {
    const area = card.querySelector('.toggle-area');
    const labelEl = area.querySelector('.panel-label');
    const contentEl = area.querySelector('.content');
    const current = area.getAttribute('data-current');
    if (current === mode && area.style.display === 'block') {
      area.style.display = 'none';
      area.setAttribute('data-current', '');
      return;
    }
    labelEl.textContent = label;
    if (mode === 'bib') {
      contentEl.innerHTML = '';
      const pre = document.createElement('pre');
      pre.textContent = html;
      contentEl.appendChild(pre);
    } else if (mode === 'abstract') {
      contentEl.textContent = html;
    } else {
      contentEl.innerHTML = html;
    }
    area.style.display = 'block';
    area.setAttribute('data-current', mode);
  }
  document.addEventListener('click', function (evt) {
    const a = evt.target.closest('a[data-action]');
    if (!a) return;
    const card = getCard(a);
    if (!card) return;
    evt.preventDefault();
    const action = a.getAttribute('data-action');
    if (action === 'abstract') {
      const text = (card.querySelector('.payload-abstract')?.textContent || 'No abstract available.').trim();
      showPanel(card, 'Abstract', text, 'abstract');
    } else if (action === 'bib') {
      const text = (card.querySelector('.payload-bibtex')?.textContent || 'No BibTeX available.').trim();
      showPanel(card, 'BibTeX', text, 'bib');
    } else if (action === 'citation') {
      const key = card.getAttribute('data-key');
      const ref = document.querySelector('#ref-' + key);
      showPanel(card, 'Citation', (ref ? ref.innerHTML : 'Citation unavailable.').trim(), 'citation');
    }
  }, false);
  document.addEventListener('click', function (evt) {
    const btn = evt.target.closest('.copy-btn');
    if (!btn) return;
    const area = getCard(btn).querySelector('.toggle-area');
    const contentEl = area.querySelector('.content');
    const pre = contentEl.querySelector('pre');
    const textToCopy = pre ? pre.textContent : contentEl.innerText;
    navigator.clipboard.writeText(textToCopy).then(() => {
      const toast = area.querySelector('.copy-toast');
      toast.style.display = 'inline-block';
      setTimeout(() => { toast.style.display = 'none'; }, 1200);
    }).catch(() => {});
  }, false);
})();
