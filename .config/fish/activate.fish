#!/usr/bin/fish

function activate
    if test (count $argv) -eq 0
        echo "Usage: activate /path/to/virtualenv"
        return 1
    end

    set -gx VIRTUAL_ENV $argv[1]
    set -gx _OLD_VIRTUAL_PATH $PATH
    set -gx PATH "$VIRTUAL_ENV/bin" $PATH

    function deactivate
        set -e VIRTUAL_ENV
        set -gx PATH $_OLD_VIRTUAL_PATH
        set -e _OLD_VIRTUAL_PATH
        echo "Virtual environment deactivated."
    end

    echo "Virtual environment activated."
end

