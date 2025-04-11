vim9script

import autoload './variables.vim'

var spinner_frames = ['▉', '▊', '▋', '▌', '▍', '▎', '▏', '▎', '▍', '▌', '▋', '▊', '▉']
var popup_args = {
    line: 2,
    col: 'cursor+1',
    minwidth: 20,
    time: 0,
    highlight: 'DiffAdd',
    border: [],
    padding: [0, 1, 0, 1],
    borderchars: variables.border_chars_array,
}

export def CreateLongRunningFunctionSystem(command: string, message: string, EndHook: func = () => 0): func
    return () => {
        var spinner_index = 0
        var UpdateSpinner = (popup_id: number) => {
            spinner_index = (spinner_index + 1) % len(spinner_frames)
            popup_settext(popup_id, spinner_frames[spinner_index] .. ' Running '  .. message ..  '...')
        }

        var popup_id = popup_create(
            spinner_frames[0] .. ' Running ' .. message .. '...',
            popup_args
        )
        var spinner_timer = timer_start(100, (timer) => UpdateSpinner(popup_id), { repeat: -1 })

        job_start(command, {
            close_cb: (channel) => {
                timer_stop(spinner_timer)
                popup_close(popup_id)
                EndHook()
            },
            exit_cb: (job, status) => {
                if (status != 0)
                    popup_notification(
                        message .. ' failed (status: ' .. status .. ')',
                        { time: 3000, highlight: 'Error' }
                    )
                endif
            } })
    }
enddef


export def CreateLongRunningFunctionVim(Function: func, message: string): func
    return () => {
        var popup_id = popup_create(
            'Running ' .. message .. '...',
            popup_args
        )

        timer_start(0, (_) => {
            try
                Function()
            catch
                popup_close(popup_id)
                popup_notification(
                    message .. ' failed: ' .. v:exception,
                    popup_args
                )
            endtry
            popup_close(popup_id)
        })
    }
enddef
