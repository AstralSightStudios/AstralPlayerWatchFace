AstFS = {}

-- 列出指定目录下的文件列表
function AstFS.listFiles(directory)
    local list = {}
    local dir, msg = lvgl.fs.open_dir(directory)
    if not dir then
        print("open dir failed: ", msg)
        return nil
    end

    while true do
        local d = dir:read()
        if not d then break end
        table.insert(list, d)
    end
    dir:close()
    return list
end

-- 根据文件名查找指定目录下文件并返回绝对路径
function AstFS.findFile(directory, filename)
    local files = AstFS.listFiles(directory)
    for _, file in ipairs(files) do
        if file == filename then
            return directory .. "/" .. file
        end
    end
    return nil
end

-- 根据文件后缀名递归查找指定目录下的文件并返回绝对路径
function AstFS.findFilesByExtension(directory, extension)
    local matchedFiles = {}
    
    local function recursiveFind(currentDir)
        local list = AstFS.listFiles(currentDir)
        if not list then return end  -- 如果无法列出文件，则返回
        
        for _, file in ipairs(list) do
            local fullPath = currentDir .. "/" .. file
            if file:match('.*%.' .. extension .. '$') then
                table.insert(matchedFiles, fullPath)
            end
            
            -- 检查当前路径是否为目录
            local subDir, msg = lvgl.fs.open_dir(fullPath)
            if subDir then
                subDir:close()
                recursiveFind(fullPath)  -- 递归搜索子目录
            end
        end
    end
    
    recursiveFind(directory)  -- 从初始目录开始递归搜索
    return matchedFiles
end

-- 写入字符串到文件
function AstFS.writeToFile(path, content)
    local f, msg = lvgl.fs.open_file(path, "w")
    if not f then
        print("failed to open file: ", msg)
        return false
    end

    f:write(content)
    f:close()
    return true
end

-- 打开文件返回字符串
function AstFS.readFile(path)
    local f, msg = lvgl.fs.open_file(path, "r")
    if not f then
        print("failed to open file: ", msg)
        return nil
    end

    local content = f:read("*a")
    f:close()
    return content
end

-- 判定文件是否存在
function AstFS.fileExists(path)
    local f, msg = lvgl.fs.open_file(path, "r")
    if f then
        f:close()
        return true
    else
        return false
    end
end

-- 复制文件
function AstFS.copyFile(sourcePath, destPath)
    local sourceFile, msg = lvgl.fs.open_file(sourcePath, "r")
    if not sourceFile then
        print("failed to open source file: ", msg)
        return false
    end

    local content = sourceFile:read("*a") -- 读取整个文件
    sourceFile:close()

    local destFile, msg = lvgl.fs.open_file(destPath, "w")
    if not destFile then
        print("failed to open destination file: ", msg)
        return false
    end

    destFile:write(content)
    destFile:close()
    return true
end

-- 删除文件
function AstFS.deleteFile(filePath)
    local result, msg = os.remove(filePath)
    if not result then
        print("failed to delete file: ", msg)
        return false
    end
    return true
end

-- 创建文件夹
function AstFS.mkDir(dir)
    os.execute("mkdir " .. dir)
end

-- 判定文件夹是否存在
function AstFS.directoryExists(directory)
    local dir, msg = lvgl.fs.open_dir(directory)
    if dir then
        dir:close()
        return true
    else
        return false, msg
    end
end