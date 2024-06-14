-----------------------------------------------------------------------------
-- Resource (C) 2024-06-14 (Nuo/诺~),All rights reserved。
-- Email：QQ197973274@163.com
-- Version 1.0.5
-----------------------------------------------------------------------------
local _M = {}

local __Version = '1.0.5'

local __ProjectName = 'Resource模块'
local __SourcecodeUrl = 'https://github.com/Nnuo0/Nnuo0/blob/main/Resource.lua'
local __OntologyAddress = debug.getinfo(1).short_src
local __UpdateContent = [[
1.0.5 2024-06-14 11:55
新增功能:获取路径内的文件
for name in resource(true) do
  --文件名name
end
1.0.4 2024-06-13 20:30
新增功能:添加新类型处理
resource:__add(type,method)
1.0.0 2024 正式发布
]]

local __LuaDir = activity.LuaDir

local __Info = 2

local Class = 'com.genesis.Resource'

local __Exists = lambda(Path)->
debug.setlocal(1,1,io.open(Path,'r'))
&&(Path&&Path:close()||false)

local __IsFile = lambda(Path)->debug.setlocal(1,1,io.open(Path))
&&(Path:read("*a")&&(Path:close())||(Path:close()&&false))

local __ResourceData = {}
__ResourceData.__type = lambda(self)->Class .. '$Data'
__ResourceData.__tostring = lambda(self)->Class .. '$Data ' .. self.S

local __GetVersion = lambda(VERSION,RESULT)->
debug.setlocal(1,1,String(VERSION).split('[.]'))&&
debug.setlocal(1,2,{1,2,3})&&table.foreachi(RESULT,function(i,v)
RESULT[i] = tointeger(VERSION[i-1]);end)||RESULT

local __VersionComparison = lambda(VERSION_1,VERSION_2)->
VERSION_1[1]<=VERSION_2[1]&&((VERSION_1[1]<VERSION_2[1]&&true)||
VERSION_1[2]<=VERSION_2[2]&&((VERSION_1[2]<VERSION_2[2]&&true)||
VERSION_1[3]<VERSION_2[3]&&true))||false

-----------------------------------------------------------------------------
-- Imports and dependencies
-----------------------------------------------------------------------------
local Typeface = luajava.bindClass "android.graphics.Typeface"

local __Cache = {}

local __Method = {
  ['png'] = function(Path)
    return loadbitmap(Path)
  end,
  ['ttf'] = function(Path)
    return Typeface.createFromFile(Path)
  end,
  ['jpg'] = 'png',
  ['__SORT__'] = {
    'png',
    'ttf',
    'jpg'
  }
}

@info
do
  local __info = debug.getinfo(__Info)
  if __info.name != nil or __info.short_src == '[C]' then
    __Info = __Info + 1
    goto info
   else
    __Info = debug.getinfo(__Info)
  end
end

_M.__type = lambda...->'userdata'
_M.__tostring = lambda...->Class

_M.__index = function(self, key)
  local __Value = rawget(self,key)
  local __Path = self.__ROOT__ .. '/' .. key
  if __Value then
    return __Value
   elseif !__Exists(__Path) then
    local __Result
    if __Cache[__Path] then
      __Result = __Cache[__Path]
    end
    for Path, suffix in ipairs(__Method.__SORT__) do
      Path = __Path .. '.' .. suffix
      if !__Result != false &&
      __Exists(Path) &&
      __IsFile(Path) then
        __Result = setmetatable({
          P = Path,
          S = suffix
        },__ResourceData)
       elseif __Result then
        break
      end
    end
    if type(__Result) == 'com.genesis.Resource$Data' then
      while type(__Method[__Result.S]) == 'string' do
        __Result.S = __Method[__Result.S]
      end
      __Cache[__Path] = __Method[__Result.S](__Result.P)
      __Result = __Cache[__Path]
    end
    return __Result||__Path
  end
  local __self = table.clone(self)
  __self.__ROOT__ = __self.__ROOT__ .. '/' .. key
  __self.__EXISTENCE__ = __Exists(__self.__ROOT__)
  return __self
end

_M.__call = function(self, Path)
  if type(Path) == 'string' then
    Path = utf8.match(__Info.source,'@(.*)/')
   elseif Path == true then
    local __files = io.ls(self.__ROOT__)
    local __key = 2
    return function()
      __key = __key + 1
      return __files[__key]
    end
  end
  self.__ROOT__=(type(Path)=='string'&&__Exists(Path))&&Path||self.__ROOT__
  return self
end

_M.__add = function(self, Type, Method)
  if type(Type) != 'string' then
    return
  end
  while type(__Method[Method]) == 'string' do
    if __Method[Method] == Type then
      return false
    end
    Method = __Method[Method]
  end
  __Method[Type] = Method
  return self
end

return setmetatable({
  __NAME__='Resource',
  __ROOT__=__LuaDir,
  __INFO__=__Info,
  __AUTHOR__='(Nuo/诺~)',
  __VERSION__=__Version,
  __SOURCECODE_URL__=__SourcecodeUrl,
  __AUTHOR_MAILBOX__='QQ197973274@163.com',
  __EXISTENCE__=true
},_M)
