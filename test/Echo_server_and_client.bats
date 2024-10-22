#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  # Start the server in the background on a specific port
  java echoserver.EchoServer 12345 &
  SERVER_PID=$!
  sleep 2  # Allow server time to start
}

teardown() {
  # Kill the server process if it's still running
  if ps -p $SERVER_PID > /dev/null; then
    kill $SERVER_PID
    wait $SERVER_PID 2>/dev/null
  fi
  sleep 1  # Ensure the server has stopped completely
}

@test "Your client/server pair handles a small bit of text" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoClient 12345 < "$BATS_TEST_DIRNAME/etc/textTest.txt" > "$BATS_TMPDIR/textTest.txt"
  run diff "$BATS_TEST_DIRNAME/etc/textTest.txt" "$BATS_TMPDIR/textTest.txt"
  [ "$status" -eq 0 ]
}

@test "Your client/server pair handles a large chunk of text" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoClient 12345 < "$BATS_TEST_DIRNAME/etc/words.txt" > "$BATS_TMPDIR/words.txt"
  run diff "$BATS_TEST_DIRNAME/etc/words.txt" "$BATS_TMPDIR/words.txt"
  [ "$status" -eq 0 ]
}

@test "Your client/server pair handles binary content" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoClient 12345 < "$BATS_TEST_DIRNAME/etc/pumpkins.jpg" > "$BATS_TMPDIR/pumpkins.jpg"
  run diff "$BATS_TEST_DIRNAME/etc/pumpkins.jpg" "$BATS_TMPDIR/pumpkins.jpg"
  [ "$status" -eq 0 ]
}
