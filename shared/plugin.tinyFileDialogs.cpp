#include "CoronaAssert.h"
#include "CoronaEvent.h"
#include "CoronaLua.h"
#include "CoronaLibrary.h"
#include "tinyfiledialogs.h"
#include <string>
#include <iostream>
#include <sstream>
#include <vector>

// ----------------------------------------------------------------------------

namespace Corona
{
	// ----------------------------------------------------------------------------

	class TinyFileDialogsLibrary
	{
	public:
		typedef TinyFileDialogsLibrary Self;

	public:
		static const char kName[];

	public:
		static int Open(lua_State* L);
		static int Finalizer(lua_State* L);
		static Self* ToLibrary(lua_State* L);

	protected:
		TinyFileDialogsLibrary();
		bool Initialize(void* platformContext);

	public:
		static int openFileDialog(lua_State* L);
		static int openFolderDialog(lua_State* L);
		static int saveFileDialog(lua_State* L);
	};

	// ----------------------------------------------------------------------------

	// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
	const char TinyFileDialogsLibrary::kName[] = "plugin.tinyFileDialogs";

	int TinyFileDialogsLibrary::Open(lua_State* L)
	{
		// Register __gc callback
		const char kMetatableName[] = __FILE__; // Globally unique string to prevent collision
		CoronaLuaInitializeGCMetatable(L, kMetatableName, Finalizer);

		//CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );
		void* platformContext = CoronaLuaGetContext(L);

		// Set library as upvalue for each library function
		Self* library = new Self;

		if (library->Initialize(platformContext))
		{
			// Functions in library
			static const luaL_Reg kFunctions[] =
			{
				{ "openFileDialog", openFileDialog },
				{ "openFolderDialog", openFolderDialog },
				{ "saveFileDialog", saveFileDialog },
				{ NULL, NULL }
			};

			// Register functions as closures, giving each access to the
			// 'library' instance via ToLibrary()
			{
				CoronaLuaPushUserdata(L, library, kMetatableName);
				luaL_openlib(L, kName, kFunctions, 1); // leave "library" on top of stack
			}
		}

		return 1;
	}

	int TinyFileDialogsLibrary::Finalizer(lua_State* L)
	{
		Self* library = (Self*)CoronaLuaToUserdata(L, 1);
		if (library)
		{
			delete library;
		}

		return 0;
	}

	TinyFileDialogsLibrary* TinyFileDialogsLibrary::ToLibrary(lua_State* L)
	{
		// library is pushed as part of the closure
		Self* library = (Self*)CoronaLuaToUserdata(L, lua_upvalueindex(1));
		return library;
	}

	TinyFileDialogsLibrary::TinyFileDialogsLibrary()
	{
	}

	bool TinyFileDialogsLibrary::Initialize(void* platformContext)
	{
		return 1;
	}

	// ----------------------------------------------------------------------------

	static std::vector<std::string> StringSplit(const std::string& s, char delim)
	{
		std::vector<std::string> result;
		std::stringstream stringStream(s);
		std::string item;

		while (getline(stringStream, item, delim))
		{
			result.push_back(item);
		}

		return result;
	}

	// ----------------------------------------------------------------------------

	// 
	int TinyFileDialogsLibrary::openFileDialog(lua_State* L)
	{
		const char* title = NULL;
		const char* singleFilterDescription = NULL;
		const char* initialPath = NULL;
		const char* filters[256] = {};
		bool multiSelect = false;
		unsigned int filterCount = 0;

		if (lua_istable(L, 1))
		{
			lua_getfield(L, 1, "title");
			if (lua_isstring(L, -1))
			{
				title = lua_tostring(L, -1);
			}
			else
			{
				CoronaLuaError(L, "tinyFileDialogs.openFileDialog() options.title (string) expected, got %s", lua_typename(L, -1));
				lua_pushnil(L);
				return 1;
			}
			lua_pop(L, 1);

			lua_getfield(L, 1, "initialPath");
			if (lua_isstring(L, -1))
			{
				initialPath = lua_tostring(L, -1);
			}
			lua_pop(L, 1);

			lua_getfield(L, 1, "singleFilterDescription");
			if (lua_isstring(L, -1))
			{
				singleFilterDescription = lua_tostring(L, -1);
			}
			else
			{
				CoronaLuaError(L, "tinyFileDialogs.openFileDialog() options.singleFilterDescription (string) expected, got %s", lua_typename(L, -1));
				lua_pushnil(L);
				return 1;
			}
			lua_pop(L, 1);

			lua_getfield(L, 1, "multiSelect");
			if (lua_isboolean(L, -1))
			{
				multiSelect = lua_toboolean(L, -1);
			}
			lua_pop(L, 1);

			lua_getfield(L, 1, "filters");
			if (lua_istable(L, -1))
			{
				filterCount = lua_objlen(L, -1);

				for (int i = 1; i <= filterCount; i++)
				{
					lua_rawgeti(L, -1, i);
					filters[i - 1] = lua_tostring(L, -1);
					lua_pop(L, 1);
				}
			}
			else
			{
				CoronaLuaError(L, "tinyFileDialogs.openFileDialog() options.filters (string) expected, got %s", lua_typename(L, -1));
				lua_pushnil(L);
				return 1;
			}
			lua_pop(L, 1);

			const char* filePath = tinyfd_openFileDialog(title, initialPath, filterCount, filters, singleFilterDescription, multiSelect);

			if (filePath != NULL)
			{
				std::string filePathString = filePath;
				const char delimiter[] = "|";

				if (filePathString.find(delimiter) != std::string::npos)
				{
					std::vector<std::string> splitString = StringSplit(filePathString, delimiter[0]);
					lua_newtable(L);

					for (int i = 1; i <= splitString.size(); i++)
					{
						lua_pushstring(L, splitString[i - 1].c_str());
						lua_rawseti(L, -2, i);
					}
				}
				else
				{
					lua_pushstring(L, filePath);
				}
			}
			else
			{
				lua_pushnil(L);
				return 1;
			}
		}
		else
		{
			CoronaLuaError(L, "tinyFileDialogs.openFileDialog() options (table) expected, got %s", lua_typename(L, 1));
			lua_pushnil(L);
		}

		return 1;
	}

	int TinyFileDialogsLibrary::openFolderDialog(lua_State* L)
	{
		const char* title = NULL;
		const char* initialPath = NULL;

		if (lua_istable(L, 1))
		{
			lua_getfield(L, 1, "title");
			if (lua_isstring(L, -1))
			{
				title = lua_tostring(L, -1);
			}
			else
			{
				CoronaLuaError(L, "tinyFileDialogs.openFolderDialog() options.title (string) expected, got %s", lua_typename(L, -1));
				lua_pushnil(L);
				return 1;
			}
			lua_pop(L, 1);

			lua_getfield(L, 1, "initialPath");
			if (lua_isstring(L, -1))
			{
				initialPath = lua_tostring(L, -1);
			}
			lua_pop(L, 1);

			const char* folderPath = tinyfd_selectFolderDialog(title, initialPath);

			if (folderPath != NULL)
			{
				lua_pushstring(L, folderPath);
			}
			else
			{
				lua_pushnil(L);
				return 1;
			}
		}
		else
		{
			CoronaLuaError(L, "tinyFileDialogs.openFolderDialog() options (table) expected, got %s", lua_typename(L, 1));
			lua_pushnil(L);
		}

		return 1;
	}

	int TinyFileDialogsLibrary::saveFileDialog(lua_State* L)
	{
		const char* title = NULL;
		const char* singleFilterDescription = NULL;
		const char* initialPath = NULL;
		const char* filters[256] = {};
		unsigned int filterCount = 0;

		if (lua_istable(L, 1))
		{
			lua_getfield(L, 1, "title");
			if (lua_isstring(L, -1))
			{
				title = lua_tostring(L, -1);
			}
			else
			{
				CoronaLuaError(L, "tinyFileDialogs.saveFileDialog() options.title (string) expected, got %s", lua_typename(L, -1));
				lua_pushnil(L);
				return 1;
			}
			lua_pop(L, 1);

			lua_getfield(L, 1, "initialPath");
			if (lua_isstring(L, -1))
			{
				initialPath = lua_tostring(L, -1);
			}
			lua_pop(L, 1);

			lua_getfield(L, 1, "singleFilterDescription");
			if (lua_isstring(L, -1))
			{
				singleFilterDescription = lua_tostring(L, -1);
			}
			else
			{
				CoronaLuaError(L, "tinyFileDialogs.saveFileDialog() options.singleFilterDescription (string) expected, got %s", lua_typename(L, -1));
				lua_pushnil(L);
				return 1;
			}
			lua_pop(L, 1);

			lua_getfield(L, 1, "filters");
			if (lua_istable(L, -1))
			{
				filterCount = lua_objlen(L, -1);

				for (int i = 1; i <= filterCount; i++)
				{
					lua_rawgeti(L, -1, i);
					filters[i - 1] = lua_tostring(L, -1);
					lua_pop(L, 1);
				}
			}
			else
			{
				CoronaLuaError(L, "tinyFileDialogs.saveFileDialog() options.filters (string) expected, got %s", lua_typename(L, -1));
				lua_pushnil(L);
				return 1;
			}
			lua_pop(L, 1);

			const char* filePath = tinyfd_saveFileDialog(title, initialPath, filterCount, filters, singleFilterDescription);

			if (filePath != NULL)
			{
				lua_pushstring(L, filePath);
			}
			else
			{
				lua_pushnil(L);
				return 1;
			}
		}
		else
		{
			CoronaLuaError(L, "tinyFileDialogs.saveFileDialog() options (table) expected, got %s", lua_typename(L, 1));
			lua_pushnil(L);
		}

		return 1;
	}

	// ----------------------------------------------------------------------------

} // namespace Corona

// ----------------------------------------------------------------------------

CORONA_EXPORT
int luaopen_plugin_tinyFileDialogs(lua_State* L)
{
	return Corona::TinyFileDialogsLibrary::Open(L);
}
