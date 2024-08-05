# First-In First-Out (FIFO)
A FIFO (First-In-First-Out) is a memory array designed to control data flow between two modules. It includes embedded control logic that efficiently manages read and write operations. FIFOs are commonly used for buffering, flow control, and **Synchronization** between hardware and software or between internal modules of a chip.
</br> 
There are two types of FIFO's:
- **Synchronous FIFO**: Data is read and written on the same clock, primarily used for buffering data.
- **Asynchronous FIFO**: Data is read and written on different clocks, mainly used for transmitting data between two clock domains.
</br> </br>

The overflow and underflow conditions have been taken care of with the help of empty and full registers.
FIFO Stands for first in first Out which means that the first elernent enters into the buffer
and corræs out first.
When an attempt is made to read data from an empty FIFO it is called an **underflow**. The design should have an **empty** to avoid getting invalid values. </br>
When an attempt is made to write data into the already full FIFO. it is called an **overflow**. The design should have a **full** flag to avoid losing the data sent from the previous module. </br>
This repository contains the Verilog code to implement a synchronous FIFO, along with an automatic validating testbench to ensure proper functionality.  The testbench streamlines verification by:
- Generating test vectors to validate read and write operations.
- Ensuring data integrity and synchronization through comparisons like the **compare_data** task.
- Evaluating the FIFO's performance under diverse conditions, including edge cases and boundary scenarios.
