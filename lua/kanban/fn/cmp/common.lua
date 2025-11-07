local M = {}

local DUE_TOKENS = {
  '@today', '@1d', '@2d', '@3d', '@5d', '@7d',
  '@1w', '@2w', '@3w',
  '@1m', '@2m', '@3m',
  '@1y', '@2y',
  '@su', '@mo', '@tu', '@we', '@th', '@fr', '@sa',
  '@nmo', '@ntu', '@nwe', '@nth', '@nfr', '@nsa', '@nsu',
}

local WEEKDAY_OFFSET = { su = 0, mo = 1, tu = 2, we = 3, th = 4, fr = 5, sa = 6 }

local SECONDS_IN_DAY = 24 * 60 * 60
local SECONDS_IN_WEEK = 7 * SECONDS_IN_DAY

---Create a shallow unique copy of the given list while preserving order.
---@generic T
---@param list T[]
---@param key_fn fun(item: T): any
---@return T[]
function M.unique(list, key_fn)
  local seen, result = {}, {}
  local selector = key_fn or function(value)
    return value
  end
  for _, value in ipairs(list) do
    local key = selector(value)
    if key ~= nil and key ~= '' and not seen[key] then
      seen[key] = true
      table.insert(result, value)
    end
  end
  return result
end

local function format_date(time_value)
  return os.date('@%Y/%m/%d', time_value)
end

---Expand known due tokens (e.g. "@today", "@2d") into concrete dates.
---@param token string
---@return string|nil
function M.expand_due_token(token)
  if not token or token:sub(1, 1) ~= '@' then
    return nil
  end

  if token == '@today' or token == '@tod' or token == '@to' then
    return format_date(os.time())
  end

  local days = token:match('^@(%d+)d$')
  if days then
    return format_date(os.time() + (tonumber(days) * SECONDS_IN_DAY))
  end

  local weeks = token:match('^@(%d+)w$')
  if weeks then
    return format_date(os.time() + (tonumber(weeks) * SECONDS_IN_WEEK))
  end

  local months = token:match('^@(%d+)m$')
  if months then
    local calendar = os.date('*t')
    for _ = 1, tonumber(months) do
      if calendar.month == 12 then
        calendar.year = calendar.year + 1
        calendar.month = 1
      else
        calendar.month = calendar.month + 1
      end
    end
    return string.format('@%04d/%02d/%02d', calendar.year, calendar.month, calendar.day)
  end

  local years = token:match('^@(%d+)y$')
  if years then
    local calendar = os.date('*t')
    calendar.year = calendar.year + tonumber(years)
    return string.format('@%04d/%02d/%02d', calendar.year, calendar.month, calendar.day)
  end

  do
    local month, day = token:match('^@/(%d%d)/(%d%d)$')
    if month and day then
      local calendar = os.date('*t')
      return string.format('@%04d/%s/%s', calendar.year, month, day)
    end
  end

  do
    local day = token:match('^@//(%d%d)$')
    if day then
      local calendar = os.date('*t')
      return string.format('@%04d/%02d/%s', calendar.year, calendar.month, day)
    end
  end

  do
    local week_prefix, weekday = token:match('^@(n*)([a-z][a-z])$')
    if weekday then
      local step_weeks = #week_prefix
      local base = os.time()
      local today = os.date('*t')
      local sunday = base - ((today.wday - 1) * SECONDS_IN_DAY)
      local target = sunday + (step_weeks * SECONDS_IN_WEEK)
      local offset = WEEKDAY_OFFSET[weekday]
      if offset ~= nil then
        target = target + (offset * SECONDS_IN_DAY)
        return format_date(target)
      end
    end
  end

  return nil
end

---Return due token matches for the given prefix.
---@param prefix string
---@return table[]
function M.due_token_matches(prefix)
  if not prefix or prefix == '' then
    return {}
  end

  local matches = {}
  local direct = M.expand_due_token(prefix)
  if direct then
    table.insert(matches, { token = prefix, expanded = direct, is_direct = true })
  end

  for _, token in ipairs(DUE_TOKENS) do
    if token:sub(1, #prefix) == prefix then
      local expanded = M.expand_due_token(token)
      if expanded then
        table.insert(matches, { token = token, expanded = expanded, is_direct = token == prefix })
      end
    end
  end

  return M.unique(matches, function(item)
    return item.expanded
  end)
end

---@class KanbanCmpDueMatch
---@field token string
---@field expanded string
---@field is_direct boolean

---Map due token matches with a builder function.
---@generic T
---@param prefix string
---@param build fun(match: KanbanCmpDueMatch): T|nil
---@return T[]
function M.map_due_matches(prefix, build)
  if type(build) ~= 'function' then
    return {}
  end

  local items = {}
  for _, match in ipairs(M.due_token_matches(prefix)) do
    local item = build(match)
    if item ~= nil then
      table.insert(items, item)
    end
  end

  return items
end

---Collect unique tags from the current kanban state.
---@param kanban table|nil
---@return string[]
function M.collect_tags(kanban)
  local tags = {}
  if not kanban or not kanban.items or not kanban.items.lists then
    return tags
  end

  for _, list in ipairs(kanban.items.lists) do
    if list and list.tasks then
      for _, task in ipairs(list.tasks) do
        if task and type(task.tag) == 'table' then
          for _, tag in ipairs(task.tag) do
            if type(tag) == 'string' and tag ~= '' then
              table.insert(tags, tag)
            end
          end
        end
      end
    end
  end

  return M.unique(tags)
end

---Return existing tags that match the given completion prefix.
---@param kanban table|nil
---@param prefix string
---@return string[]
function M.tag_prefix_matches(kanban, prefix)
  if not prefix or prefix == '' then
    return {}
  end

  local tags = {}
  local normalized = prefix:sub(2):lower()
  for _, tag in ipairs(M.collect_tags(kanban)) do
    local lower_tag = string.lower(tag)
    if lower_tag:sub(1, #normalized) == normalized then
      table.insert(tags, tag)
    end
  end

  return tags
end

---Map tag matches with a builder function.
---@generic T
---@param kanban table|nil
---@param prefix string
---@param build fun(tag: string): T|nil
---@return T[]
function M.map_tag_matches(kanban, prefix, build)
  if type(build) ~= 'function' then
    return {}
  end

  local items = {}
  for _, tag in ipairs(M.tag_prefix_matches(kanban, prefix)) do
    local item = build(tag)
    if item ~= nil then
      table.insert(items, item)
    end
  end

  return items
end

return M
