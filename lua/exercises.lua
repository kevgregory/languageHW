function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end  

-- Write your first then lower case function here
function first_then_lower_case(a, p)
  for _, item in ipairs(a) do
    if p(item) then
      return string.lower(item)
    end
  end
  return nil
end

-- Write your powers generator here
function powers_generator(base, limit)
  local generator = function()
      local power = 0
      local value = base ^ power

      while value <= limit do
          coroutine.yield(value)
          power = power + 1
          value = base ^ power
      end
  end
  return coroutine.create(generator)
end

-- Write your say function here
function say(word)
  local words = {}
  
  local function chain(new_word)
      if new_word == nil then
          return table.concat(words, " ")
      end
      table.insert(words, new_word)
      return chain
  end

  return chain(word)
end

-- Write your line count function here
function meaningful_line_count(filename)
  local file, err = io.open(filename, "r")
  if not file then
      error("No such file")
  end
  
  local count = 0
  for line in file:lines() do
      local trimmed_line = line:match("^%s*(.-)%s*$")
      if #trimmed_line > 0 and trimmed_line:sub(1, 1) ~= "#" then
          count = count + 1
      end
  end
  
  file:close()
  return count
end

-- Write your Quaternion table here
Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
  local self = setmetatable({}, Quaternion)
  self.a = a
  self.b = b
  self.c = c
  self.d = d
  return self
end

function Quaternion.__add(q1, q2)
  return Quaternion.new(q1.a + q2.a, q1.b + q2.b, q1.c + q2.c, q1.d + q2.d)
end

function Quaternion.__mul(q1, q2)
  return Quaternion.new(
      q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,
      q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,
      q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,
      q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a
  )
end

function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

function Quaternion.__eq(q1, q2)
  return q1.a == q2.a and q1.b == q2.b and q1.c == q2.c and q1.d == q2.d
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

function Quaternion:__tostring()
  local output = ""
  local terms = {"", "i", "j", "k"}
  local coefficients = self:coefficients()

  for i, coefficient in ipairs(coefficients) do
      if coefficient ~= 0 then
          if output ~= "" and coefficient > 0 then
              output = output .. "+"
          end
          
          local abs_val = math.abs(coefficient)

          if i == 1 then
              output = output .. tostring(coefficient)
          else
              if abs_val == 1 then
                  output = output .. (coefficient < 0 and "-" or "") .. terms[i]
              else
                  output = output .. tostring(coefficient) .. terms[i]
              end
          end
      end
  end
  return output == "" and "0" or output
end




