# 🚦 Synchronous Traffic Light Controller

A **SystemVerilog Finite State Machine (FSM)** that controls a traffic light synchronously with the system clock.

### Sequence

```text
🔴 RED (5 cycles) → 🟢 GREEN (10 cycles) → 🟡 YELLOW (3 cycles) → RED
```

---

## 📌 Overview

The controller uses:

- **FSM** to control the traffic-light sequence.
- **4-bit counter** to measure clock cycles.
- **Synchronous clock** for state and counter updates.
- **Reset** to initialize the system to RED.

---

## 🚦 States

| State     | Encoding |  Duration | Output       |
| --------- | -------- | --------: | ------------ |
| 🔴 RED    | `2'b00`  |  5 cycles | `red = 1`    |
| 🟢 GREEN  | `2'b01`  | 10 cycles | `green = 1`  |
| 🟡 YELLOW | `2'b10`  |  3 cycles | `yellow = 1` |

The unused encoding `2'b11` is treated as an invalid state and returns the FSM to **RED**.

---

## 🔢 System Variables

### Inputs

| Signal  | Type    | Description                  |
| ------- | ------- | ---------------------------- |
| `clk`   | `logic` | System clock                 |
| `reset` | `logic` | Resets the controller to RED |

### Outputs

| Signal    | Width | Description           |
| --------- | ----: | --------------------- |
| `state`   | 2-bit | Current FSM state     |
| `counter` | 4-bit | Current cycle counter |
| `red`     | 1-bit | RED light output      |
| `green`   | 1-bit | GREEN light output    |
| `yellow`  | 1-bit | YELLOW light output   |

### Internal FSM Variables

```systemverilog
current_state
next_state
```

- `current_state`: stores the current registered state.
- `next_state`: determines the state entered on the next clock edge.

---

## ⏱ Counter

The counter is:

```systemverilog
logic [3:0] counter;
```

A 4-bit counter represents values from `0` to `15`.

The transition limits are:

```text
RED    → counter == 4  → GREEN
GREEN  → counter == 9  → YELLOW
YELLOW → counter == 2  → RED
```

The counter resets to `0` whenever the FSM enters a new state.

---

## 🔄 State Diagram

```text
                  counter == 4
          ┌────────────────────────┐
          │                        ▼
      ┌───────┐                ┌─────────┐
      │  RED  │                │  GREEN  │
      │  5    │───────────────►│   10    │
      │cycles │                │ cycles  │
      └───▲───┘                └────┬────┘
          │                         │
          │                         │ counter == 9
          │                         ▼
          │                    ┌─────────┐
          └────────────────────│ YELLOW  │
             counter == 2      │    3    │
                               │ cycles  │
                               └─────────┘
```

### Transition Table

| Current State | Condition      | Next State |
| ------------- | -------------- | ---------- |
| RED           | `counter == 4` | GREEN      |
| RED           | Otherwise      | RED        |
| GREEN         | `counter == 9` | YELLOW     |
| GREEN         | Otherwise      | GREEN      |
| YELLOW        | `counter == 2` | RED        |
| YELLOW        | Otherwise      | YELLOW     |
| Invalid       | Any            | RED        |

---

## 🧠 FSM Design

This is a **Moore FSM** because the outputs depend only on the current state.

```text
Current State
      │
      ▼
┌──────────────┐
│ Output Logic │
└──────┬───────┘
       │
       ├── RED    → red = 1
       ├── GREEN  → green = 1
       └── YELLOW → yellow = 1
```

The FSM follows:

```text
RED → GREEN → YELLOW → RED
```

---

## 🕐 Sequential & Combinational Logic

### Sequential Logic

`always_ff @(posedge clk)` updates:

```text
current_state
counter
```

Only the rising edge of the clock changes the registered values.

### Combinational Logic

`always_comb` determines:

```text
next_state
red
green
yellow
```

This separates **state storage** from **decision/output logic**, making the design easier to understand and verify.

---

## 🔄 Reset

When reset is asserted:

```text
current_state = RED
counter       = 0
```

After reset is released, the normal sequence begins:

```text
RED → GREEN → YELLOW → RED
```

---

## 🧪 Testbench

The testbench verifies:

1. Reset behavior.
2. Correct state sequence.
3. Correct timing for every state.
4. Correct traffic-light outputs.
5. Continuous operation of the FSM.

Expected timing:

```text
RED      █████
GREEN         ██████████
YELLOW                  ███
RED                         █████
```

Only **one light must be active at a time**.

---

## ▶️ Simulation

Using Icarus Verilog:

<p align="center">
  <img src="images\red.png" width="250"/>
  <img src="images\green.png" width="250"/>
  <img src="images\yellow.png" width="250"/>
</p>

---

## 🎓 Learning Objectives

This project demonstrates:

- SystemVerilog
- Finite State Machines
- Moore FSM
- State encoding
- Sequential logic
- Combinational logic
- Clocked registers
- Counters
- Reset logic
- RTL design
- Testbench verification
- Simulation and waveform analysis

---

## 🚀 Future Improvements

Possible extensions include:

- 🚶 Pedestrian crossing
- 🚗 Vehicle sensors
- 🚨 Emergency vehicle priority
- ⏱ Configurable timing
- Multiple intersections
- Manual override
- SystemVerilog assertions

Timing can also be parameterized:

```systemverilog
parameter int RED_TIME = 5;
parameter int GREEN_TIME = 10;
parameter int YELLOW_TIME = 3;
```

---

## 📄 License

Educational and demonstration project. Feel free to modify and extend it for learning and coursework.
