local M = {}

function M.new(fs, textutils, save_path)
    local self = {
        fs = fs,
        textutils = textutils,
        save_path = save_path
    }

    function self:generateTaskId()
        return "MC-" .. math.random(1000, 9999)
    end

    function self:generateId()
        return math.random(1000, 999999)
    end

    function self:findTaskById(tasks, id)
        for _, task in ipairs(tasks) do
            if task.id == id then
                return true
            end
        end
        return false
    end

    function self:generateUniqueTaskId(tasks)
        local id = self:generateTaskId()
        repeat
            id = self:generateTaskId()
        until not self:findTaskById(tasks, id)
        return id
    end

    function self:loadTasks()
        local tasks = {}
        if self.fs.exists(self.save_path) then
            local f = self.fs.open(self.save_path, "r")
            local loaded = self.textutils.unserialize(f.readAll()) or {}
            f.close()
            for _, task in ipairs(loaded) do
                if type(task.text) == "string" then
                    table.insert(tasks, {
                        id = task.id,
                        text = task.text,
                        status = type(task.status) == "number" and task.status or 1,
                        priority = task.priority or 1,
                        startDate = task.startDate or nil,
                        description = task.description or nil,
                    })
                end
            end
        end
        return tasks
    end

    function self:moveTask(task, status)
        task.status = status
        if task.startDate == nil then
            task.startDate = os.date("%c")
        end
    end

    function self:saveTasks(tasks)
        if tasks == nil then
            error("Tasks cannot be nil")
        end
        if not self.fs.exists("data") then
            self.fs.makeDir("data")
        end
        local f = self.fs.open(self.save_path, "w")
        f.write(self.textutils.serialize(tasks))
        f.close()
    end

    function self:saveTask(task)
        local tasks = self:loadTasks()
        if tasks == nil then
            error("Tasks cannot be nil")
        end

        for i, t in ipairs(tasks) do
            if t.id == task.id then
                tasks[i] = task
                break
            end
        end

        if not self.fs.exists("data") then
            self.fs.makeDir("data")
        end
        local f = self.fs.open(self.save_path, "w")
        f.write(self.textutils.serialize(tasks))
        f.close()
    end

    function self:deleteTaskById(id)
        local tasks = self:loadTasks()
        for i, task in ipairs(tasks) do
            if task.id == id then
                table.remove(tasks, i)
                self:saveTasks(tasks)
                return true
            end
        end
        return false
    end

    function self:addTask(text, tasks)
        local id = self:generateUniqueTaskId(tasks)
        table.insert(
            tasks,
            {
                id = id,
                text = text,
                status = 1,
                priority = 1,
                description = nil,
            }
        )
        self:saveTasks(tasks)
    end

    function self:deleteTaskById(id)
        local tasks = self:loadTasks()
        for i, task in ipairs(tasks) do
            if task.id == id then
                table.remove(tasks, i)
                self:saveTasks(tasks)
                return true
            end
        end
        return false
    end

    function self:getStatusColor(status)
        if status == 2 then
            return colors.blue
        elseif status == 3 then
            return colors.green
        else
            return colors.gray
        end
    end

    return self
end

return M
