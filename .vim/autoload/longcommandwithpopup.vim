vim9script

var spinner_frames = ['▉', '▊', '▋', '▌', '▍', '▎', '▏', '▎', '▍', '▌', '▋', '▊', '▉']

var spinner_idx = 0
def UpdateSpinner(popup_id: number, message: string)
  spinner_idx = (spinner_idx + 1) % len(spinner_frames)
  popup_settext(popup_id, spinner_frames[spinner_idx] .. ' Running '  .. message ..  '...')
enddef

export def CreateLongRunningFunction(command: string, message: string, EndHook: func = () => 0): func
    return () => {
        var popup_id = popup_create(spinner_frames[0] .. ' Running ' .. message .. '...', { line: 1, col: 10, minwidth: 20, time: 0, highlight: 'Question', border: [], padding: [1, 2, 1, 2] })
        var spinner_timer = timer_start(100, (timer) => UpdateSpinner(popup_id, message), { repeat: -1 })

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
