#!/usr/bin/env bats

setup() {
  BATS_TMPDIR=$(mktemp --directory)
  cd ../src
  rm -f echoserver/*.class
  javac echoserver/*.java
  java echoserver.EchoServer &
  sleep 1  # Allow the server to start up
  cd ../test
}

teardown() {
  rm -rf "$BATS_TMPDIR"
  kill %1
  # Ensure that the server shuts down completely before moving on
  sleep 1
}

@test "Your client/server pair handles a small bit of text" {
  cd ../src
  java echoserver.EchoClient < ../test/etc/textTest.txt > "$BATS_TMPDIR"/textTest.txt
  run diff ../test/etc/textTest.txt "$BATS_TMPDIR"/textTest.txt
  cd ../test

  [ "$status" -eq 0 ]
}

@test "Your client/server pair handles a large chunk of text" {
  cd ../src
  java echoserver.EchoClient < ../test/etc/words.txt > "$BATS_TMPDIR"/words.txt
  run diff ../test/etc/words.txt "$BATS_TMPDIR"/words.txt
  cd ../test

  [ "$status" -eq 0 ]
}

@test "Your client/server pair handles binary content" {
  cd ../src
  java echoserver.EchoClient < ../test/etc/pumpkins.jpg > "$BATS_TMPDIR"/pumpkins.jpg
  run diff ../test/etc/pumpkins.jpg "$BATS_TMPDIR"/pumpkins.jpg
  cd ../test

  [ "$status" -eq 0 ]
}
