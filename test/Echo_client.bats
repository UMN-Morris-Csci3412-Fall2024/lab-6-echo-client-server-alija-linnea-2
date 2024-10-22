#!/usr/bin/env bats

setup() {
  BATS_TMPDIR=$(mktemp --directory)
  cd ../src
  rm -f echoserver/*.class
  javac -d ../bin echoserver/*.java
  java -cp ../bin echoserver.EchoServer &
  sleep 1  # Allow server to start
  cd ../test
}

teardown() {
  rm -rf "$BATS_TMPDIR"
  kill %1
  sleep 1  # Ensure the server shuts down completely
}

@test "Your client code compiles" {
  cd ../src
  rm -f echoserver/EchoClient.class
  run javac -d ../bin echoserver/EchoClient.java
  cd ../test
  [ "$status" -eq 0 ]
}

@test "Your client runs successfully" {
  cd ../bin
  java echoserver.EchoClient < ../test/etc/textTest.txt
  status=$?
  cd ../test
  [ "$status" -eq 0 ]
}

@test "Your client handles a small bit of text" {
  cd ../bin
  java echoserver.EchoClient < ../test/etc/textTest.txt > "$BATS_TMPDIR"/textTest.txt
  run diff ../test/etc/textTest.txt "$BATS_TMPDIR"/textTest.txt
  cd ../test
  [ "$status" -eq 0 ]
}

@test "Your client handles a large chunk of text" {
  cd ../bin
  java echoserver.EchoClient < ../test/etc/words.txt > "$BATS_TMPDIR"/words.txt
  run diff ../test/etc/words.txt "$BATS_TMPDIR"/words.txt
  cd ../test
  [ "$status" -eq 0 ]
}

@test "Your client handles binary content" {
  cd ../bin
  java echoserver.EchoClient < ../test/etc/pumpkins.jpg > "$BATS_TMPDIR"/pumpkins.jpg
  run diff ../test/etc/pumpkins.jpg "$BATS_TMPDIR"/pumpkins.jpg
  cd ../test
  [ "$status" -eq 0 ]
}
