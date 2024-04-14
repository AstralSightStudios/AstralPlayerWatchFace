AstJson = {}

function AstJson.parseJson(str)
    local json, pos, err = nil, 1, nil
    local function decode()
      pos = string.find(str, '%S', pos)
      if string.sub(str, pos, pos) == '{' then
        pos = pos + 1
        local table = {}
        while true do
          local key = decode()
          if err then return nil end
          pos = string.find(str, '%S', pos)
          if string.sub(str, pos, pos) ~= ':' then
            err = 'Expected colon after key'
            return nil
          end
          pos = pos + 1
          table[key] = decode()
          if err then return nil end
          pos = string.find(str, '%S', pos)
          local chr = string.sub(str, pos, pos)
          if chr == '}' then
            pos = pos + 1
            return table
          elseif chr ~= ',' then
            err = 'Expected comma after pair'
            return nil
          end
          pos = pos + 1
        end
      elseif string.sub(str, pos, pos) == '[' then
        pos = pos + 1
        local array = {}
        local i = 1
        while true do
          local val = decode()
          if err then return nil end
          array[i] = val
          i = i + 1
          pos = string.find(str, '%S', pos)
          local chr = string.sub(str, pos, pos)
          if chr == ']' then
            pos = pos + 1
            return array
          elseif chr ~= ',' then
            err = 'Expected comma after value'
            return nil
          end
          pos = pos + 1
        end
      elseif string.sub(str, pos, pos) == '"' then
        pos = pos + 1
        local s = ''
        while true do
          local chr = string.sub(str, pos, pos)
          if chr == '"' then
            pos = pos + 1
            return s
          elseif chr == '\\' then
            pos = pos + 1
            chr = string.sub(str, pos, pos)
            if chr == 'n' then
              s = s .. '\n'
            elseif chr == 't' then
              s = s .. '\t'
            else
              s = s .. chr
            end
          else
            s = s .. chr
          end
          pos = pos + 1
        end
      elseif string.find(str, '^%-?%d+%.?%d*[eE]?[%+%-]?%d*', pos) then
        local number = string.match(str, '^%-?%d+%.?%d*[eE]?[%+%-]?%d*', pos)
        pos = pos + string.len(number)
        return tonumber(number)
      elseif string.sub(str, pos, pos + 3) == 'true' then
        pos = pos + 4
        return true
      elseif string.sub(str, pos, pos + 4) == 'false' then
        pos = pos + 5
        return false
      elseif string.sub(str, pos, pos + 3) == 'null' then
        pos = pos + 4
        return nil
      else
        err = 'Invalid JSON value'
        return nil
      end
    end
    json = decode()
    if err then
      error('Error parsing JSON: ' .. err)
    else
      return json
    end
end