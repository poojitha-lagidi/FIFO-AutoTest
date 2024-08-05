# First-In First-Out (FIFO)
A FIFO (First-In-First-Out) is a memory array designed to control data flow between two modules. It includes embedded control logic that efficiently manages read and write operations. FIFOs are commonly used for buffering, flow control, and **Synchronization** between hardware and software or between internal modules of a chip.
</br> 
There are two types of FIFO's:
- **Synchronous FIFO**: Data is read and written on the same clock, primarily used for buffering data.
- **Asynchronous FIFO**: Data is read and written on different clocks, mainly used for transmitting data between two clock domains.
</br> </br>

Overflow and underflow conditions are managed using empty and full flags. An **underflow** occurs when there is an attempt to read data from an empty FIFO. To prevent retrieving invalid values, the design should incorporate an **empty** flag. Conversely, an **overflow** occurs when there is an attempt to write data into a full FIFO. To prevent data loss from the preceding module, the design should include a **full** flag. </br> 

This repository contains the Verilog code to implement a synchronous FIFO, along with an automatic validating testbench to ensure proper functionality.  The testbench streamlines verification by:
- Generating test vectors to validate read and write operations.
- Ensuring data integrity and synchronization through comparisons like the **compare_data** task.
- Evaluating the FIFO's performance under diverse conditions, including edge cases and boundary scenarios.
