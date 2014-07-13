HandGestureRecognition
======================

Hand Gesture Recognition Code for Matlab

Realtime Implementation : http://youtu.be/4ovU9PiI9Eg

Release Date: 13 July 14

How to Use:
======================
The program is designed to take a background Image first and then the hand gesture.

After running the code:
1. When Webcam LED is on, it will pause 2 seconds and take background image snapshot.
2. A further 2 second pause and then it will take the hand gesture image snapshot.

The background is subtracted from the gesture image and the rest of the processing continues. The identification process only works on a single blob.

The identification codes may need to be adjusted. The roundness value and the number of peaks should be checked and edited for correct recognitions.


Tips:
======================
If the contrast of the background image and the test image (with hand gesture) then the subtraction process is better. A clear light and contrasting background is usually helpful when testing this code.
