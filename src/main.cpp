#include <spdlog/spdlog.h>
#include <nlohmann/json.hpp>



int main()
{
	nlohmann::json j = {{"key", "value"}, {"number", 42}};
	spdlog::info("Hello, {}", j.dump());
}
