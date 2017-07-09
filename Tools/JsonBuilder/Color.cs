using System.Globalization;

namespace JsonBuilder
{
    public struct Color
    {
        public static bool TryParse(string s, out Color color)
        {
            bool TryHexParse(string sh, out int i) => int.TryParse(sh, NumberStyles.HexNumber, null, out i);

            if (string.IsNullOrWhiteSpace(s))
            {
                color = new Color();
                return false;
            }

            if (s.Length == 6)
            {
                var redString = s.Substring(0, 2);
                var greenString = s.Substring(2, 2);
                var blueString = s.Substring(4, 2);

                if (TryHexParse(redString, out int r) &&
                    TryHexParse(greenString, out int g) &&
                    TryHexParse(blueString, out int b))
                {
                    color = new Color(r, g, b);
                    return true;
                }
            }

            if (s.Length == 3)
            {
                var redString = s.Substring(0, 1);
                var greenString = s.Substring(1, 1);
                var blueString = s.Substring(2, 1);
                redString += redString;
                greenString += greenString;
                blueString += blueString;

                if (TryHexParse(redString, out int r) &&
                    TryHexParse(greenString, out int g) &&
                    TryHexParse(blueString, out int b))
                {
                    color = new Color(r, g, b);
                    return true;
                }
            }

            color = new Color();
            return false;
        }

        public Color(int red, int green, int blue)
        {
            Red = (byte) red;
            Green = (byte) green;
            Blue = (byte) blue;
        }

        public int Red;
        public int Green;
        public int Blue;
    }
}