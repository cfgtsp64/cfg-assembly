local as = {};
as.__index = as;

local null = "null";

function as.new(name, protos)
	local self = setmetatable({name = name or "as-main", memory = {}, protos = protos or {}}, as);
	for idx = 1, #self.protos do
		self.protos[idx].exec = self:wrap(self.protos[idx]);
	end
	for idx = 0, 2048 do
		self.memory[idx] = 0;
	end
	return self;
end

function as:deconstructInstruction(inst)
	return inst[1], inst[2] or null, inst[3] or null, inst[4] or null;
end

function as:instruction2String(inst)
	return string.format("instruction: [opcode: %s, a: %s, b: %s, c: %s]", self:deconstructInstruction(inst));
end

function as:getProto(name)
	for idx = 1, #self.protos do
		if self.protos[idx].name == name then return self.protos[idx]; end
	end
end

local function concat(t, encode, a, b)
	a = a or 1; b = b or #t;
	local s = encode and "" or table.concat(t, "", a, b);
	for idx = a, b do
		s = s .. (encode and string.char(t[idx]) or "");
	end
	return s;
end

function as:wrap(proto)
	proto = proto or self:getProto(proto) or self:getProto();
	local instructions = proto.instructions;
	local max = #instructions;
	return function()
		local pc = 0;
		local function setpc(x) pc = x; end
		local function addpc(x)	pc = pc + (x or 1); end
		while true do
			addpc();
			if pc > max then
				break;
			else
				local opcode, a, b, c = self:deconstructInstruction(instructions[pc]);
				if opcode == 0 then -- ADD
					self.memory[a] = self.memory[b] + self.memory[c];
				elseif opcode == 1 then -- SUB
					self.memory[a] = self.memory[b] - self.memory[c];
				elseif opcode == 2 then -- MUL
					self.memory[a] = self.memory[b] * self.memory[c];
				elseif opcode == 3 then -- DIV
					self.memory[a] = math.floor(self.memory[b] / self.memory[c]);
				elseif opcode == 4 then -- GET
					self.memory[a] = self.memory[(b ~= null and b) or a];
				elseif opcode == 5 then -- CLEAR
					self.memory[a] = 0;
				elseif opcode == 6 then -- MOVE
					self.memory[a] = self.memory[b];
				elseif opcode == 7 then -- SET
					self.memory[a] = b;
				elseif opcode == 8 then -- COUT
					io.write(tostring(self.memory[a]));
				elseif opcode == 9 then -- COUTNL
					print(tostring(self.memory[a]));
				elseif opcode == 10 then -- COUTNLRANGE
					print(concat(self.memory, false, a, b));
				elseif opcode == 11 then -- COUTNLRANGESTR
					print(concat(self.memory, true, a, b));
				elseif opcode == 12 then -- JMP
					addpc(a);
				elseif opcode == 13 then -- SETPC
					setpc(a);
				elseif opcode == 14 then -- RESETPC
					setpc(0);
				elseif opcode == 15 then -- HALT
					os.execute("sleep " .. a);
				elseif opcode == 16 then -- KILL
					break;
				elseif opcode == 17 then -- TESTLT
					if not (self.memory[a] < self.memory[b]) then addpc(c); end
				elseif opcode == 18 then -- TESTGT
					if not (self.memory[a] > self.memory[b]) then addpc(c); end
				elseif opcode == 19 then -- TESTLE
					if not (self.memory[a] <= self.memory[b]) then addpc(c); end
				elseif opcode == 20 then -- TESTGE
					if not (self.memory[a] >= self.memory[b]) then addpc(c); end
				elseif opcode == 21 then -- TESTEQ
					if not (self.memory[a] == self.memory[b]) then addpc(c); end
				elseif opcode == 22 then -- CALL
					self:getProto(a).exec();
				elseif opcode == 23 then -- RETURN
					return table.move(self.memory, a, b, 1, {});
				end
			end
		end
	end
end

return as;
