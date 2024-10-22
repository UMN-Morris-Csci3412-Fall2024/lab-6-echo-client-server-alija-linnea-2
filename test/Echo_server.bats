#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/../src/echoserver" || exit 1
  rm -f *.class
  javac EchoServer.java
}

@test "Your server code compiles" {
  cd "$BATS_TEST_DIRNAME/../src/echoserver" || exit 1
  run javac EchoServer.java
  [ "$status" -eq 0 ]
}

@test "Your server starts successfully" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoServer &
  status=$?
  sleep 2
  kill %1
  [ "$status" -eq 0 ]
}

@test "Your server handles a small bit of text" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoServer &
  sleep 2

  java echoserver.EchoClient < "$BATS_TEST_DIRNAME/etc/textTest.txt" > "$BATS_TMPDIR/textTest.txt"
  run diff "$BATS_TEST_DIRNAME/etc/textTest.txt" "$BATS_TMPDIR/textTest.txt"

  kill %1
  [ "$status" -eq 0 ]
}

@test "Your server handles a large chunk of text" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoServer &
  sleep 2

  java echoserver.EchoClient < "$BATS_TEST_DIRNAME/etc/words.txt" > "$BATS_TMPDIR/words.txt"
  run diff "$BATS_TEST_DIRNAME/etc/words.txt" "$BATS_TMPDIR/words.txt"

  kill %1
  [ "$status" -eq 0 ]
}

@test "Your server handles binary content" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoServer &
  sleep 2

  java echoserver.EchoClient < "$BATS_TEST_DIRNAME/etc/pumpkins.jpg" > "$BATS_TMPDIR/pumpkins.jpg"
  run diff "$BATS_TEST_DIRNAME/etc/pumpkins.jpg" "$BATS_TMPDIR/pumpkins.jpg"

  kill %1
  [ "$status" -eq 0 ]
}
