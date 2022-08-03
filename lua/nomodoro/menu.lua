
local Menu
local event


local function on_close()
end


local function check_dependencies()
    local ok, t = pcall(require, "nui.menu")
    if ok then
        Menu = t
    else 
        return false
    end

    ok, t = pcall(require, "nui.utils.autocmd")
    if ok then
        event = t.event
    else
        return false
    end

    return true
end

local has_dependencies = check_dependencies()

local M = {}

local function show(nomodoro)
    if not has_dependencies then return end

    local popup_options = {
        border = {
            style = 'rounded',
            padding = { 1, 3 },
        },
        position = '50%',
        size = {
            width = '25%',
        },
        opacity = 1,
    }

    local menu_options = {
        keymap = {
            focus_next = { 'j', '<Down>', '<Tab>' },
            focus_prev = { 'k', '<Up>', '<S-Tab>' },
            close = { '<Esc>', '<C-c>' },
            submit = { '<CR>', '<Space>' },
        },
        lines = {
            Menu.item('Start Work'),
            Menu.item('Start Break'),
            Menu.item('Stop'),
        },
        on_close = on_close,
        on_submit = function(item)
            if item.text == 'Start Work' then
                start(vim.g.nomodoro.work_time)
            elseif item.text == 'Start Break' then
                start(vim.g.nomodoro.break_time)
            elseif item.text == 'Stop' then
                nomodoro.stop()
            end
        end
    }
    local menu = Menu(popup_options, menu_options)

    menu:mount()

    menu:on(event.BufLeave, function()
        menu:unmount()
    end, { once = true })
    menu:map('n', 'q', function()
        menu:unmount()
    end, { noremap = true })

end

M.show = show
M.has_dependencies = has_dependencies

return M
