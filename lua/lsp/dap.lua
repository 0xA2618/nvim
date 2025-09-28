local dap = require("dap")
dap.adapters.go = {
    type = "executable",
    command = "node",
    args = { "/path/to/vscode-go/dist/debugAdapter.js" },
}
dap.configurations.go = {
    {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
    },
}
