@echo off
echo === Curl Sample Project Tests ===
echo.

echo 1. Testing curl version:
docker run --rm cleanstart/curl:latest curl --version
echo.

echo 2. Testing simple HTTP GET request:
docker run --rm cleanstart/curl:latest curl -s https://httpbin.org/get
echo.

echo 3. Testing HTTP POST request:
docker run --rm cleanstart/curl:latest curl -s -X POST https://httpbin.org/post -H "Content-Type: application/json" -d "{\"test\": \"data\"}"
echo.

echo 4. Testing file download:
if not exist data mkdir data
docker run --rm -v %cd%\data:/workspace cleanstart/curl:latest curl -s -o /workspace/test.json https://httpbin.org/json
echo File downloaded successfully!
echo.

echo 5. Checking downloaded file:
dir data
echo.

echo === All tests completed! ===
pause
