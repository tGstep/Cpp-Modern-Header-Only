#include <spdlog.h>
#include <json.hpp>



int main()
{
	nlohmann::json j = {{"key", "value"}, {"number", 42}};
	spdlog::info("Hello, {}", j.dump());
}
