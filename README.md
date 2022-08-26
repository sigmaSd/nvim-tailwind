# nvim-tailwind
Autocomplete tailwind classes inside **tw``**

## Install

using packer:
```lua
    use({
        'sigmaSd/nvim-tailwind',
        requires = {
            "jose-elias-alvarez/null-ls.nvim",
            'nvim-treesitter/nvim-treesitter',
        }
    })
```

## Usage

- `RegisterTw` activates completion
- `DergisterTw` deactivates completion

After activating completion, you will be able to get lsp completion of tw classes inside **tw``** expression ![image](https://user-images.githubusercontent.com/22427111/186982918-fbbdd71a-e291-4916-a833-61dea712b769.png)
