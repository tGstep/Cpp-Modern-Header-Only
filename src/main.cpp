#include <iostream>
#include <spdlog/spdlog.h>
#include <nlohmann/json.hpp>

int main() {
    spdlog::info("Hello, world!");
    nlohmann::json j = {{"key", "value"}, {"number", 42}};
    std::cout << j.dump(2) << std::endl;
    return 0;
}
