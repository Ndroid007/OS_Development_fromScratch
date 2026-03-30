Descriptor table :

- `**Index 1**` : 8 bytes		-------->>	
    ```text
    00 00 00 00 00 00 00 00         # First entry should be zero
    ```

- `**Index 2**` : 8 bytes		-------->>

    ```text
    
    ff ff		Segment Size/limit lower bits

    00 00		|----> lower 3 bytes(24 bits) will set base address to 0
    00		    |__|
            
    9a		Attribute -> |P 1-bit|DPL 2-bits|S 1-bit|Type 4-bits (E C R A)|
                            1	      00	   1		1010

    cf  		Combination of attr and upper 4 bits of Segment size/limit
                Upper 4-bits are attribs and lower 4 bits are upper bits of limit
                |G|D|0|A|LIMIT|
                 1 1   0 1111

    00		Upper 8-bits of base address
    ```