#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoServer &
  sleep 2
}

teardown() {
  kill %1
  sleep 1
}

@test "Your client code compiles" {
  cd "$BATS_TEST_DIRNAME/../src/echoserver" || exit 1
  run javac EchoClient.java
  [ "$status" -eq 0 ]
}

@test "Your client runs successfully" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  run java echoserver.EchoClient < "$BATS_TEST_DIRNAME/etc/textTest.txt"
  [ "$status" -eq 0 ]
}

@test "Your client handles a small bit of text" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoClient < "$BATS_TEST_DIRNAME/etc/textTest.txt" > "$BATS_TMPDIR/textTest.txt"
  run diff "$BATS_TEST_DIRNAME/etc/textTest.txt" "$BATS_TMPDIR/textTest.txt"
  [ "$status" -eq 0 ]
}

@test "Your client handles a large chunk of text" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoClient < "$BATS_TEST_DIRNAME/etc/words.txt" > "$BATS_TMPDIR/words.txt"
  run diff "$BATS_TEST_DIRNAME/etc/words.txt" "$BATS_TMPDIR/words.txt"
  [ "$status" -eq 0 ]
}

@test "Your client handles binary content" {
  cd "$BATS_TEST_DIRNAME/../bin" || exit 1
  java echoserver.EchoClient < "$BATS_TEST_DIRNAME/etc/pumpkins.jpg" > "$BATS_TMPDIR/pumpkins.jpg"
  run diff "$BATS_TEST_DIRNAME/etc/pumpkins.jpg" "$BATS_TMPDIR/pumpkins.jpg"
  [ "$status" -eq 0 ]
}
