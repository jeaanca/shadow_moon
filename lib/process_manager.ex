defmodule ProcessManager do
    def whoami() do
        {user, _} = System.cmd(Atom.to_string(:whoami), [])
        user
        |> String.replace("\n", "")
        |> String.trim
    end

    def remove_space(content, by_char) do      
        Regex.replace(~r/ {1,}/, String.trim(content), by_char)
    end

    def break_lines(head) do
        head
        |> remove_space("|")
        |> String.split("|")
    end

    def process_in_list([head | []]) do
        head
    end

    def process_in_list([head | tail]) do
        n_head = break_lines head
        [n_head] ++ process_in_list(tail)
    end

    def ao_to_string([head | []]) do
        Atom.to_string(head)
    end
    def ao_to_string([head | tail]) do
        Atom.to_string(head) <> "," <> ao_to_string(tail)
    end

    def ps_all do
        ps([:pid, :user, :pri, :nice, :pcpu, :pmem, :time, :comm])
    end

    def ps(cols) do
        user = whoami()
        ao = ao_to_string(cols)
        params = ["-ao", ao, "-U", user]
        process = System.cmd("ps", params)
        [head, _tail] = Tuple.to_list process

        String.split(head, "\n")
        |> process_in_list
    end

    def detail_process(pid) do
        File.read("/proc/#{pid}/status")
    end

end