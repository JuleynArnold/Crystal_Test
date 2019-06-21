require "benchmark"

io = IO::Memory.new

Benchmark.ips do |x|
    x.report("Server Startup Benchmark Release") do
        require "../src/main.cr"
    end
end
