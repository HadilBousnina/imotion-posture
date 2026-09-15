class SquatCounter:


    def __init__(self):

        self.state = "up"

        self.count = 0

        self.down_threshold = 100
        self.up_threshold = 160

        # Prevent multiple counts
        self.cooldown = 0
        self.cooldown_frames = 15



    def update(self, features):

        left_knee = features.get(
            "left_knee"
        )

        right_knee = features.get(
            "right_knee"
        )


        if left_knee is None or right_knee is None:
            return self.count



        avg_knee = (
            left_knee +
            right_knee
        ) / 2


        # -------------------------
        # Cooldown management
        # -------------------------

        if self.cooldown > 0:
            self.cooldown -= 1



        # -------------------------
        # Down phase
        # -------------------------

        if avg_knee < self.down_threshold:

            self.state = "down"



        # -------------------------
        # Up phase
        # -------------------------

        if (
            avg_knee > self.up_threshold
            and self.state == "down"
            and self.cooldown == 0
        ):

            self.count += 1

            self.state = "up"

            self.cooldown = self.cooldown_frames



        return self.count