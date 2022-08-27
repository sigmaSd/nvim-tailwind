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

After activating completion, you will be able to get lsp completion of tw classes inside **tw``** expression
![image](https://user-images.githubusercontent.com/22427111/187043201-fa7b2127-0572-4f4b-a4fb-16b297fb1902.png)
