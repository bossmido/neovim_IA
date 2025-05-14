return {
    {
        "echasnovski/mini.nvim",
        config = function()
            local mini_files = require("mini.files")
            mini_files.setup({
                content = {
                    sort = function(e)
                        local result = {}
                        local files = {}

                        for _, v in ipairs(e) do
                            if v.fs_type and v.fs_type == "directory" then
                                table.insert(result, v)
                            else
                                table.insert(files, v)
                            end
                        end

                        table.sort(result, function(a, b)
                            local charA, charB = a.name:byte(1), b.name:byte(1)

                            local isUpperA, isUpperB = charA < 97, charB < 97

                            if isUpperA ~= isUpperB then
                                return isUpperA
                            end

                            return a.name < b.name
                        end)

                        table.sort(files, function(a, b)
                            local aDot = a.name:sub(1, 1) == "."
                            local bDot = b.name:sub(1, 1) == "."

                            if aDot ~= bDot then
                                return aDot
                            end

                            local nameA, extA = a.name:match("(.+)%.(.+)")
                            local nameB, extB = b.name:match("(.+)%.(.+)")

                            extA, nameA = extA or "", nameA or a.name
                            extB, nameB = extB or "", nameB or b.name

                            if extA == extB then
                                local isUpperA = nameA:sub(1, 1):match("%u") ~= nil
                                local isUpperB = nameB:sub(1, 1):match("%u") ~= nil

                                if isUpperA ~= isUpperB then
                                    return isUpperA
                                end

                                return nameA < nameB
                            end
                            return extA < extB
                        end)

                        table.move(files, 1, #files, #result + 1, result)

                        return result
                    end,
                },
            })

            vim.keymap.set("n", "-", function()
                if vim.bo.buftype == "" or vim.bo.buftype == "nofile" then
                    mini_files.open(vim.api.nvim_buf_get_name(0))
                end
            end)
        end
    }
}
