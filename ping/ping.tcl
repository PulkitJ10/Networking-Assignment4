## \file ping.tcl

# Event Scheduler Object creation.
set ns [new Simulator]

# Creating trace objects and nam objects.
set traceFile [open traceOutput.tr w]
set namFile [open namOutput.nam w]
$ns trace-all $traceFile
$ns namtrace-all $namFile

# Finish procedure
proc finish {} {
    global ns traceFile namFile
    $ns flush-trace
    close $traceFile
    close $namFile
    exec gawk -f packet_drop.awk traceOutput.tr &
    exec nam namOutput.nam &
    exit 0
}

## Constant storing number of nodes
set NODE_COUNT 6

## Create the network
for {set i 0} {$i < $NODE_COUNT} {incr i} {
    set node($i) [$ns node]
}

## Creating Duplex-Link
## {lnode rnode bandwidth}
set links {
    {0 2 1}
    {1 2 1}
    {2 3 0.01}
    {3 4 1}
    {3 5 1}
}
for {set i 0} {$i < [llength $links]} {incr i} {
    set lnode $node([lindex $links $i 0])
    set rnode $node([lindex $links $i 1])
    $ns duplex-link $lnode $rnode [lindex $links $i 2]Mb 10ms DropTail
}

Agent/Ping instproc recv {from rtt} {
        $self instvar node_
        puts "node [$node_ id] received ping answer from \
              $from with round-trip-time $rtt ms."
}

## Creating ping agents
for {set i 0} {$i < $NODE_COUNT} {incr i} {
    set pingAgent($i) [new Agent/Ping]
}

## Attaching ping agents to nodes
for {set i 0} {$i < $NODE_COUNT} {incr i} {
    $ns attach-agent $node($i) $pingAgent($i)
}

## Setting different queue limits
set queueLimits {
    {0 2 2}
    {2 1 3}
    {2 3 2}
    {3 4 4}
    {5 3 4}
}
for {set i 0} {$i < [llength $queueLimits]} {incr i} {
    set lnode $node([lindex $queueLimits $i 0])
    set rnode $node([lindex $queueLimits $i 1])
    set limit [lindex $queueLimits $i 2]
    $ns queue-limit $lnode $rnode $limit
}

$ns connect $pingAgent(0) $pingAgent(4)
$ns connect $pingAgent(5) $pingAgent(1)

$pingAgent(0) set class_ 0
$pingAgent(4) set class_ 0
$pingAgent(5) set class_ 1
$pingAgent(1) set class_ 1

$ns color 0 red
$ns color 1 blue

$ns at 0.1 "$pingAgent(0) send"
$ns at 0.2 "$pingAgent(0) send"
$ns at 0.3 "$pingAgent(0) send"
$ns at 0.4 "$pingAgent(0) send"
$ns at 0.5 "$pingAgent(0) send"
$ns at 0.6 "$pingAgent(0) send"
$ns at 0.7 "$pingAgent(0) send"
$ns at 0.8 "$pingAgent(0) send"
$ns at 0.9 "$pingAgent(0) send"
$ns at 1.0 "$pingAgent(0) send"
$ns at 1.1 "$pingAgent(0) send"
$ns at 1.2 "$pingAgent(0) send"
$ns at 1.3 "$pingAgent(0) send"
$ns at 1.4 "$pingAgent(0) send"
$ns at 1.5 "$pingAgent(0) send"
$ns at 1.6 "$pingAgent(0) send"
$ns at 1.7 "$pingAgent(0) send"
$ns at 1.8 "$pingAgent(0) send"
$ns at 1.9 "$pingAgent(0) send"
$ns at 2.0 "$pingAgent(0) send"
$ns at 2.1 "$pingAgent(0) send"
$ns at 2.2 "$pingAgent(0) send"
$ns at 2.3 "$pingAgent(0) send"
$ns at 2.4 "$pingAgent(0) send"
$ns at 2.5 "$pingAgent(0) send"
$ns at 2.6 "$pingAgent(0) send"
$ns at 2.7 "$pingAgent(0) send"
$ns at 2.8 "$pingAgent(0) send"
$ns at 2.9 "$pingAgent(0) send"

$ns at 0.1 "$pingAgent(5) send"
$ns at 0.2 "$pingAgent(5) send"
$ns at 0.3 "$pingAgent(5) send"
$ns at 0.4 "$pingAgent(5) send"
$ns at 0.5 "$pingAgent(5) send"
$ns at 0.6 "$pingAgent(5) send"
$ns at 0.7 "$pingAgent(5) send"
$ns at 0.8 "$pingAgent(5) send"
$ns at 0.9 "$pingAgent(5) send"
$ns at 1.0 "$pingAgent(5) send"
$ns at 1.1 "$pingAgent(5) send"
$ns at 1.2 "$pingAgent(5) send"
$ns at 1.3 "$pingAgent(5) send"
$ns at 1.4 "$pingAgent(5) send"
$ns at 1.5 "$pingAgent(5) send"
$ns at 1.6 "$pingAgent(5) send"
$ns at 1.7 "$pingAgent(5) send"
$ns at 1.8 "$pingAgent(5) send"
$ns at 1.9 "$pingAgent(5) send"
$ns at 2.0 "$pingAgent(5) send"
$ns at 2.1 "$pingAgent(5) send"
$ns at 2.2 "$pingAgent(5) send"
$ns at 2.3 "$pingAgent(5) send"
$ns at 2.4 "$pingAgent(5) send"
$ns at 2.5 "$pingAgent(5) send"
$ns at 2.6 "$pingAgent(5) send"
$ns at 2.7 "$pingAgent(5) send"
$ns at 2.8 "$pingAgent(5) send"
$ns at 2.9 "$pingAgent(5) send"


$ns at 3.0 "finish"

$ns run
