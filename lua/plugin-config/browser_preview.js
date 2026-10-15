const http = require('http');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const targetFilePath = process.argv[2];
if (!targetFilePath || !fs.existsSync(targetFilePath)) {
  console.error('Usage: node preview_server.js <markdown-file-path>');
  process.exit(1);
}

const absFilePath = path.resolve(targetFilePath);
const targetDir = path.dirname(absFilePath);
const fileName = path.basename(absFilePath);

let clients = [];

fs.watch(absFilePath, () => {
  clients.forEach(res => {
    try {
      res.write('data: reload\n\n');
    } catch (_) {}
  });
});

function getHtml() {
  const content = fs.readFileSync(absFilePath, 'utf-8');
  const jsonContent = JSON.stringify(content);
  const jsonFileName = JSON.stringify(fileName);

  return `<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${fileName} - 预览</title>
  
  <script src="https://cdn.jsdelivr.net/npm/marked@9.1.6/marked.min.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/github-markdown-css@5.5.0/github-markdown.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/highlight.js@11.9.0/styles/github.min.css" id="hljs-light">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/highlight.js@11.9.0/styles/github-dark.min.css" id="hljs-dark" disabled>
  <script src="https://cdn.jsdelivr.net/npm/highlight.js@11.9.0/lib/highlight.min.js"></script>

  <style>
    :root {
      --bg-color: #ffffff;
      --sidebar-bg: #f6f8fa;
      --border-color: #d0d7de;
      --text-color: #1f2328;
      --link-color: #0969da;
      --active-bg: #e6edf5;
      --toggle-bg: #f3f4f6;
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --bg-color: #0d1117;
        --sidebar-bg: #161b22;
        --border-color: #30363d;
        --text-color: #e6edf3;
        --link-color: #4493f8;
        --active-bg: #1f242c;
        --toggle-bg: #21262d;
      }
    }

    * { box-sizing: border-box; }
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      background-color: var(--bg-color);
      color: var(--text-color);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Noto Sans", Helvetica, Arial, sans-serif;
      transition: background-color 0.2s, color 0.2s;
    }

    #app {
      display: flex;
      height: 100vh;
      overflow: hidden;
    }

    /* Left Collapsible TOC Sidebar */
    #sidebar {
      width: 300px;
      min-width: 300px;
      background: var(--sidebar-bg);
      border-right: 1px solid var(--border-color);
      height: 100%;
      overflow-y: auto;
      padding: 20px 14px;
      transition: margin-left 0.25s cubic-bezier(0.4, 0, 0.2, 1);
      display: flex;
      flex-direction: column;
    }

    #sidebar.collapsed {
      margin-left: -300px;
    }

    .sidebar-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding-bottom: 12px;
      border-bottom: 1px solid var(--border-color);
      margin-bottom: 14px;
    }

    .sidebar-title {
      font-size: 14px;
      font-weight: 700;
      letter-spacing: 0.5px;
      text-transform: uppercase;
      color: var(--text-color);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    /* Tree structure */
    .toc-tree {
      list-style: none;
      padding-left: 0;
      margin: 0;
      font-size: 13px;
    }

    .toc-item {
      margin: 4px 0;
    }

    .toc-header-row {
      display: flex;
      align-items: center;
      padding: 5px 8px;
      border-radius: 6px;
      cursor: pointer;
      text-decoration: none;
      color: var(--text-color);
      transition: background-color 0.15s;
    }

    .toc-header-row:hover {
      background-color: var(--active-bg);
    }

    .toc-header-row.active {
      font-weight: 600;
      color: var(--link-color);
      background-color: var(--active-bg);
    }

    .toc-toggle-btn {
      width: 16px;
      height: 16px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 10px;
      margin-right: 4px;
      color: #8c959f;
      cursor: pointer;
      user-select: none;
      border-radius: 3px;
    }

    .toc-toggle-btn:hover {
      background: var(--border-color);
    }

    .toc-toggle-btn.empty {
      visibility: hidden;
    }

    .toc-toggle-btn.collapsed {
      transform: rotate(-90deg);
    }

    .toc-link {
      flex: 1;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      text-decoration: none;
      color: inherit;
    }

    .toc-children {
      list-style: none;
      padding-left: 16px;
      margin: 0;
    }

    .toc-children.collapsed {
      display: none;
    }

    /* Main Content Area */
    #main-content {
      flex: 1;
      height: 100%;
      overflow-y: auto;
      padding: 30px 48px;
      position: relative;
      scroll-behavior: smooth;
    }

    /* Float Toggle Sidebar Button */
    #sidebar-toggle-btn {
      position: fixed;
      top: 14px;
      left: 14px;
      z-index: 1000;
      background: var(--toggle-bg);
      color: var(--text-color);
      border: 1px solid var(--border-color);
      border-radius: 6px;
      padding: 6px 10px;
      font-size: 13px;
      cursor: pointer;
      box-shadow: 0 2px 8px rgba(0,0,0,0.12);
      display: flex;
      align-items: center;
      gap: 6px;
      transition: all 0.2s;
    }

    #sidebar-toggle-btn:hover {
      border-color: var(--link-color);
      color: var(--link-color);
    }

    .markdown-body {
      max-width: 900px;
      margin: 0 auto;
      background: transparent !important;
    }

    .markdown-body h1,
    .markdown-body h2,
    .markdown-body h3,
    .markdown-body h4,
    .markdown-body h5,
    .markdown-body h6 {
      position: relative;
    }

    .markdown-body h1::before {
      content: "# ";
      color: #8c959f;
      font-weight: normal;
      margin-right: 4px;
      user-select: none;
      opacity: 0.7;
    }
    .markdown-body h2::before {
      content: "## ";
      color: #8c959f;
      font-weight: normal;
      margin-right: 4px;
      user-select: none;
      opacity: 0.7;
    }
    .markdown-body h3::before {
      content: "### ";
      color: #8c959f;
      font-weight: normal;
      margin-right: 4px;
      user-select: none;
      opacity: 0.7;
    }
    .markdown-body h4::before {
      content: "#### ";
      color: #8c959f;
      font-weight: normal;
      margin-right: 4px;
      user-select: none;
      opacity: 0.7;
    }
    .markdown-body h5::before {
      content: "##### ";
      color: #8c959f;
      font-weight: normal;
      margin-right: 4px;
      user-select: none;
      opacity: 0.7;
    }
    .markdown-body h6::before {
      content: "###### ";
      color: #8c959f;
      font-weight: normal;
      margin-right: 4px;
      user-select: none;
      opacity: 0.7;
    }

    .markdown-body pre {
      border: 1px solid var(--border-color) !important;
      border-radius: 8px !important;
      padding: 16px !important;
      background-color: var(--sidebar-bg) !important;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08) !important;
      position: relative;
    }

    .markdown-body pre code {
      background: transparent !important;
      padding: 0 !important;
      font-family: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, "Liberation Mono", monospace;
      font-size: 13px !important;
      line-height: 1.5 !important;
    }

    .markdown-body :not(pre) > code {
      background-color: var(--toggle-bg) !important;
      border: 1px solid var(--border-color);
      border-radius: 4px;
      padding: 2px 6px;
      font-size: 85%;
    }
  </style>
</head>
<body>
  <button id="sidebar-toggle-btn" title="折叠/展开侧边栏">
    <span id="toggle-icon">◀</span> 目录
  </button>

  <div id="app">
    <div id="sidebar">
      <div class="sidebar-header">
        <span class="sidebar-title" id="doc-title">${fileName}</span>
      </div>
      <div id="toc-container"></div>
    </div>
    <div id="main-content">
      <article class="markdown-body" id="article-content"></article>
    </div>
  </div>

  <script>
    const rawMarkdown = ${jsonContent};
    const fileName = ${jsonFileName};

    // Dark/Light Theme listener
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)');
    function updateTheme() {
      const isDark = prefersDark.matches;
      document.getElementById('hljs-dark').disabled = !isDark;
      document.getElementById('hljs-light').disabled = isDark;
      document.documentElement.setAttribute('data-color-mode', isDark ? 'dark' : 'light');
      document.documentElement.setAttribute('data-dark-theme', 'dark');
      document.documentElement.setAttribute('data-light-theme', 'light');
    }
    prefersDark.addEventListener('change', updateTheme);
    updateTheme();

    // Markdown Parser Configuration
    marked.setOptions({
      highlight: function(code, lang) {
        if (lang && hljs.getLanguage(lang)) {
          try { return hljs.highlight(code, { language: lang }).value; } catch (_) {}
        }
        return hljs.highlightAuto(code).value;
      },
      gfm: true,
      breaks: false,
    });

    const parsedHtml = marked.parse(rawMarkdown);
    const contentEl = document.getElementById('article-content');
    contentEl.innerHTML = parsedHtml;

    // Build TOC tree
    const headings = contentEl.querySelectorAll('h1, h2, h3, h4, h5, h6');
    const tocContainer = document.getElementById('toc-container');
    const tocList = document.createElement('ul');
    tocList.className = 'toc-tree';

    let headingData = [];
    headings.forEach((h, idx) => {
      const level = parseInt(h.tagName[1]);
      const text = h.textContent.trim();
      let id = h.id;
      if (!id) {
        id = 'heading-' + idx + '-' + encodeURIComponent(text.replace(/\\s+/g, '-').toLowerCase());
        h.id = id;
      }
      headingData.push({ level, text, id, el: h });
    });

    // Build hierarchical tree
    function buildTree(list, startLevel = 1) {
      const rootUl = document.createElement('ul');
      rootUl.className = startLevel === 1 ? 'toc-tree' : 'toc-children';

      let i = 0;
      while (i < list.length) {
        const item = list[i];
        const li = document.createElement('li');
        li.className = 'toc-item';

        const row = document.createElement('div');
        row.className = 'toc-header-row';

        // Check if there are sub-headings
        let subItems = [];
        let j = i + 1;
        while (j < list.length && list[j].level > item.level) {
          subItems.push(list[j]);
          j++;
        }

        const toggleBtn = document.createElement('span');
        toggleBtn.className = 'toc-toggle-btn' + (subItems.length > 0 ? '' : ' empty');
        toggleBtn.textContent = '▼';

        const link = document.createElement('a');
        link.className = 'toc-link';
        link.href = '#' + item.id;
        link.textContent = item.text;
        link.onclick = (e) => {
          e.preventDefault();
          history.replaceState(null, null, '#' + item.id);
          item.el.scrollIntoView({ behavior: 'smooth' });
          document.querySelectorAll('.toc-header-row').forEach(r => r.classList.remove('active'));
          row.classList.add('active');
        };

        row.appendChild(toggleBtn);
        row.appendChild(link);
        li.appendChild(row);

        if (subItems.length > 0) {
          const subUl = buildTree(subItems, item.level + 1);
          toggleBtn.onclick = (e) => {
            e.stopPropagation();
            const isCol = subUl.classList.toggle('collapsed');
            toggleBtn.classList.toggle('collapsed', isCol);
          };
          li.appendChild(subUl);
          i = j - 1;
        }

        rootUl.appendChild(li);
        i++;
      }
      return rootUl;
    }

    if (headingData.length > 0) {
      tocContainer.appendChild(buildTree(headingData, 1));
    } else {
      tocContainer.innerHTML = '<div style="color:#8c959f;font-size:12px;padding:8px;">(暂无标题大纲)</div>';
    }

    // Handle Anchor on Initial Load
    if (window.location.hash) {
      const target = document.querySelector(window.location.hash);
      if (target) {
        setTimeout(() => target.scrollIntoView({ behavior: 'smooth' }), 100);
      }
    }

    // Sidebar Toggle
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.getElementById('sidebar-toggle-btn');
    const toggleIcon = document.getElementById('toggle-icon');

    toggleBtn.onclick = () => {
      const isCollapsed = sidebar.classList.toggle('collapsed');
      toggleIcon.textContent = isCollapsed ? '▶' : '◀';
    };

    // Live Reload via SSE
    const evtSource = new EventSource('/__events');
    evtSource.onmessage = (e) => {
      if (e.data === 'reload') {
        window.location.reload();
      }
    };
  </script>
</body>
</html>`;
}

const server = http.createServer((req, res) => {
  const urlPath = req.url.split('?')[0];

  if (urlPath === '/__events') {
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
    });
    clients.push(res);
    req.on('close', () => {
      clients = clients.filter(c => c !== res);
    });
    return;
  }

  // Handle local relative images/assets
  if (urlPath.startsWith('/_assets/')) {
    const relPath = decodeURIComponent(urlPath.replace('/_assets/', ''));
    const fullPath = path.join(targetDir, relPath);
    if (fs.existsSync(fullPath) && fs.statSync(fullPath).isFile()) {
      return fs.createReadStream(fullPath).pipe(res);
    }
  }

  // Any other URL (including subpaths or hash refreshes) returns the main preview page -> NO 404!
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(getHtml());
});

server.listen(0, '127.0.0.1', () => {
  const port = server.address().port;
  const url = 'http://127.0.0.1:' + port;
  console.log('PREVIEW_SERVER_READY:' + url);

  // Open in default macOS browser
  spawn('open', [url], { detached: true, stdio: 'ignore' }).unref();
});
