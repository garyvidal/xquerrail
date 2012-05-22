xquery version "1.0" encoding "UTF-8";

(: This file was generated on Mon May 14, 2012 19:24 (UTC-04) by REx v5.15 which is Copyright (c) 1979-2012 by Gunther Rademacher <grd@gmx.net> :)
(: REx command line: CSS3Selectors.ebnf -tree -trace -faster -xquery :)

(:~
 : The parser that was generated for the CSS3Selectors grammar.
 :)
module namespace p="CSS3Selectors";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

(:~
 : The codepoint to charclass mapping for 7 bit codepoints.
 :)
declare variable $p:MAP0 as xs:integer+ :=
(
  0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 1, 0, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 4, 5, 6, 7, 4, 4,
  8, 9, 10, 11, 12, 13, 14, 15, 4, 16, 17, 17, 17, 18, 19, 20, 19, 17, 17, 21, 4, 4, 22, 23, 4, 4, 4, 4, 4, 4, 4, 4, 4,
  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 24, 25, 26, 27, 28, 4, 29, 29, 29, 29, 30, 31, 28, 28, 28,
  28, 28, 28, 28, 32, 33, 28, 28, 28, 28, 34, 28, 28, 28, 28, 28, 28, 4, 35, 4, 36, 4
);

(:~
 : The codepoint to charclass mapping for codepoints below the surrogate block.
 :)
declare variable $p:MAP1 as xs:integer+ :=
(
  54, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62,
  62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 133, 126, 149,
  185, 164, 169, 200, 228, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216,
  216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216,
  216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 216, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 1, 0, 2, 3, 0, 0, 37, 4, 5, 6, 7, 4, 4, 8, 9, 10, 11, 12, 13, 14, 15,
  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 24, 25, 26, 27, 28, 16, 17, 17, 17, 18, 19, 20, 19, 17, 17, 21, 4, 4,
  22, 23, 4, 29, 29, 29, 29, 30, 31, 28, 28, 28, 28, 28, 28, 28, 32, 33, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28,
  28, 28, 28, 28, 34, 28, 28, 28, 28, 28, 28, 4, 35, 4, 36, 4
);

(:~
 : The codepoint to charclass mapping for codepoints above the surrogate block.
 :)
declare variable $p:MAP2 as xs:integer+ :=
(
  57344, 65536, 65533, 1114111, 28, 28
);

(:~
 : The token-set-id to DFA-initial-state mapping.
 :)
declare variable $p:INITIAL as xs:integer+ :=
(
  1, 2, 3, 4, 5, 262, 7, 8, 9, 10, 11, 12, 13, 14, 271, 16, 17, 18, 19, 20, 21, 22, 279, 280, 281
);

(:~
 : The DFA transition table.
 :)
declare variable $p:TRANSITION as xs:integer+ :=
(
  701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 701, 1006, 878, 608, 615, 1444, 1524, 937,
  1513, 1523, 913, 1525, 917, 1560, 1545, 994, 701, 1006, 878, 608, 615, 1444, 1524, 701, 907, 1523, 764, 1525, 1127,
  1548, 1545, 1314, 701, 1006, 878, 608, 615, 1444, 640, 701, 679, 639, 649, 641, 672, 690, 687, 1187, 701, 701, 701,
  701, 1132, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 701, 859, 714, 1132, 726, 703, 1586, 1432,
  1357, 700, 1369, 701, 725, 1370, 1371, 701, 701, 701, 806, 813, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705,
  706, 701, 701, 701, 734, 1132, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 701, 656, 662, 1132, 748,
  703, 1586, 739, 702, 749, 1028, 701, 747, 1029, 1030, 701, 701, 701, 701, 962, 699, 717, 1586, 758, 716, 700, 1329,
  701, 772, 1330, 1664, 701, 784, 787, 789, 799, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 842, 839,
  853, 1132, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 701, 664, 1635, 871, 1632, 703, 1586, 863,
  702, 700, 704, 701, 698, 705, 706, 701, 776, 775, 845, 886, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706,
  701, 936, 925, 931, 1145, 945, 984, 957, 1513, 1523, 1519, 1525, 1590, 1548, 1526, 1314, 701, 701, 750, 970, 977,
  1002, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 701, 1050, 1014, 893, 1024, 1105, 1038, 1058, 1066,
  1074, 1082, 1090, 1098, 1113, 1121, 701, 701, 1050, 1014, 893, 1024, 1105, 1140, 1058, 1153, 1161, 1303, 1174, 1182,
  1457, 1314, 701, 701, 1050, 1014, 893, 1024, 1105, 1195, 1058, 1209, 1217, 1303, 1225, 1233, 1457, 1239, 701, 701,
  1050, 1014, 893, 1024, 1105, 1140, 1058, 1153, 1161, 1259, 1267, 1182, 1282, 1275, 701, 701, 1050, 1014, 893, 1024,
  1105, 1195, 1058, 1209, 1217, 1303, 1290, 1233, 1457, 1239, 701, 701, 620, 1612, 1619, 699, 703, 1586, 863, 702, 700,
  704, 701, 698, 705, 706, 701, 701, 701, 1298, 1132, 1667, 1311, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701,
  701, 791, 1016, 1322, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 701, 701, 1650, 1657, 699, 703,
  1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 1356, 1345, 1351, 1338, 1365, 820, 1379, 1386, 1404, 1392, 630,
  1396, 1410, 631, 1166, 701, 1419, 701, 1418, 1132, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 701,
  701, 1427, 1132, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 1049, 900, 1044, 1201, 1440, 984, 1452,
  1513, 1523, 1519, 1525, 1590, 1548, 1526, 1314, 701, 1049, 900, 1044, 1251, 1440, 1105, 1465, 1058, 1153, 1161, 1303,
  1174, 1182, 1457, 1314, 701, 1049, 900, 1044, 1251, 1440, 1105, 1465, 1058, 1490, 1161, 1303, 1174, 1182, 1457, 1314,
  701, 1049, 900, 1044, 1251, 1440, 1105, 1465, 1058, 1153, 1161, 1498, 1174, 1182, 1457, 1314, 701, 1049, 900, 1044,
  1201, 1440, 1626, 1506, 1513, 1523, 1519, 1525, 1590, 1548, 1526, 1314, 701, 1049, 900, 1044, 1201, 1440, 984, 1534,
  1513, 1564, 1478, 1525, 1482, 1548, 1526, 1314, 701, 1049, 900, 1044, 1201, 1440, 984, 1452, 1513, 1542, 1519, 1556,
  1245, 989, 1526, 1314, 701, 625, 831, 1572, 1579, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 701,
  949, 1598, 1605, 699, 703, 1586, 863, 702, 700, 704, 701, 698, 705, 706, 701, 1006, 878, 608, 1643, 826, 1524, 1586,
  1472, 1523, 764, 1525, 1127, 1548, 1545, 1314, 701, 413, 421, 413, 0, 413, 413, 399, 399, 0, 0, 0, 413, 0, 0, 0, 0,
  3072, 0, 0, 0, 0, 3584, 0, 0, 0, 27, 31, 47, 48, 51, 53, 1740, 0, 0, 0, 0, 1208, 1210, 60, 62, 2506, 62, 0, 2506, 0,
  1740, 0, 91, 0, 0, 34, 0, 0, 0, 0, 34, 0, 0, 0, 0, 0, 0, 1792, 1792, 1740, 0, 0, 0, 104, 0, 0, 1208, 0, 1210, 0, 60,
  0, 62, 2506, 0, 115, 1208, 1210, 60, 62, 2506, 1740, 0, 0, 0, 0, 33, 34, 0, 0, 0, 0, 0, 0, 0, 0, 33, 34, 0, 0, 0, 0,
  33, 0, 0, 0, 0, 0, 0, 1408, 33, 34, 0, 1280, 34, 0, 0, 0, 0, 0, 0, 38, 0, 0, 0, 38, 0, 0, 0, 33, 33, 1280, 1280, 0, 0,
  33, 1280, 0, 0, 0, 0, 0, 0, 0, 35, 0, 1408, 1408, 33, 33, 34, 34, 0, 2484, 0, 1707, 0, 55, 0, 1408, 33, 34, 0, 0, 0,
  0, 0, 0, 2048, 0, 0, 0, 2560, 0, 0, 0, 0, 2560, 0, 0, 0, 0, 0, 0, 1920, 0, 2560, 0, 1180, 0, 0, 0, 1184, 0, 0, 43, 43,
  0, 43, 43, 43, 0, 1180, 0, 0, 0, 1184, 0, 0, 53, 54, 27, 31, 33, 34, 0, 0, 421, 0, 0, 0, 3584, 0, 3584, 0, 0, 0, 2688,
  0, 0, 0, 2688, 0, 0, 0, 0, 0, 0, 2048, 2048, 39, 0, 2688, 2688, 39, 2688, 0, 0, 33, 0, 0, 0, 0, 33, 33, 34, 34, 0,
  1792, 0, 1180, 0, 0, 0, 1184, 0, 0, 413, 413, 0, 413, 399, 421, 2048, 0, 1180, 0, 0, 0, 1184, 0, 0, 1197, 1180, 0, 0,
  1198, 1184, 1180, 1180, 0, 1184, 1180, 0, 1180, 0, 1184, 0, 33, 0, 34, 2484, 2484, 1707, 1707, 0, 55, 0, 69, 0, 0,
  1180, 30, 26, 26, 0, 30, 26, 0, 2842, 26, 26, 0, 26, 0, 0, 0, 0, 0, 0, 0, 1180, 33, 34, 0, 50, 0, 0, 0, 0, 0, 0, 2176,
  0, 50, 0, 2484, 2484, 1707, 0, 0, 1180, 0, 0, 0, 1184, 1408, 0, 35, 2944, 2944, 0, 2944, 2944, 2944, 0, 1180, 0, 0, 0,
  1184, 0, 0, 1707, 0, 1180, 1184, 33, 34, 2484, 1707, 0, 0, 83, 33, 34, 2484, 1707, 0, 33, 34, 0, 35, 0, 0, 0, 0, 0, 6,
  413, 413, 0, 1572, 0, 0, 0, 0, 0, 0, 1920, 1920, 33, 34, 1585, 1572, 0, 0, 0, 0, 0, 33, 1280, 0, 0, 0, 1585, 0, 2496,
  2484, 1729, 66, 0, 1180, 1180, 1180, 0, 1180, 0, 0, 0, 0, 0, 0, 0, 1572, 1222, 1184, 1223, 33, 72, 34, 73, 2507, 1741,
  78, 0, 80, 0, 1236, 1237, 86, 87, 2484, 2520, 1707, 1753, 90, 0, 92, 0, 94, 0, 1248, 1249, 98, 99, 2532, 1765, 102, 0,
  103, 0, 105, 0, 1259, 1260, 109, 110, 2543, 1776, 0, 113, 0, 0, 1707, 0, 1209, 1211, 61, 63, 114, 0, 1180, 1184, 116,
  117, 2550, 1783, 0, 120, 0, 33, 34, 2484, 1707, 0, 0, 0, 69, 0, 0, 1180, 0, 0, 0, 1184, 0, 1585, 0, 2496, 2484, 1729,
  0, 0, 1180, 1180, 0, 0, 1184, 1184, 1741, 0, 0, 0, 0, 1236, 1237, 86, 87, 2484, 2520, 1707, 1753, 0, 0, 0, 47, 48, 51,
  53, 0, 1765, 0, 0, 0, 0, 0, 0, 1259, 1260, 109, 110, 2543, 1776, 0, 0, 0, 60, 62, 2506, 1740, 0, 1585, 0, 2496, 2484,
  1729, 67, 0, 1180, 1180, 1180, 0, 1184, 1184, 1184, 1741, 67, 0, 81, 0, 1236, 1237, 86, 87, 2484, 2520, 1707, 1753,
  67, 0, 81, 1765, 67, 0, 81, 0, 0, 106, 1259, 1260, 109, 110, 2543, 1776, 67, 81, 0, 0, 33, 34, 2484, 1707, 0, 0, 0,
  83, 0, 0, 1180, 1197, 1180, 0, 1184, 1198, 1184, 0, 95, 0, 1248, 1249, 98, 99, 2532, 1765, 0, 0, 0, 0, 95, 0, 1259, 0,
  95, 0, 33, 34, 2484, 1707, 95, 0, 1180, 1184, 116, 117, 2550, 1783, 1765, 67, 0, 81, 0, 0, 0, 1259, 3200, 0, 0, 0,
  3200, 0, 0, 0, 1248, 1249, 98, 99, 2532, 640, 512, 0, 0, 0, 0, 33, 34, 2484, 1707, 0, 1920, 0, 1180, 0, 0, 0, 1184, 0,
  0, 2304, 0, 1408, 33, 34, 0, 0, 0, 27, 1180, 27, 0, 31, 1184, 31, 27, 27, 0, 31, 27, 0, 27, 27, 27, 0, 27, 0, 0, 0, 0,
  0, 0, 0, 1280, 47, 48, 0, 51, 0, 0, 0, 0, 0, 1280, 34, 0, 0, 0, 51, 51, 2484, 51, 1707, 0, 68, 27, 31, 31, 47, 47, 48,
  48, 51, 51, 53, 53, 0, 68, 0, 82, 0, 0, 27, 53, 0, 0, 0, 82, 27, 31, 47, 48, 51, 53, 0, 0, 82, 3456, 0, 0, 0, 3456, 0,
  0, 0, 3456, 40, 0, 0, 0, 40, 0, 0, 0, 1280, 1280, 34, 34, 0, 33, 34, 0, 2484, 0, 0, 0, 0, 421, 0, 0, 0, 2484, 2484,
  2484, 2484, 1707, 0, 0, 1180, 1184, 116, 117, 2550, 1783, 2484, 2484, 2496, 2484, 1729, 0, 0, 1180, 0, 1184, 33, 33,
  34, 34, 2484, 2484, 1707, 1707, 0, 69, 0, 0, 0, 0, 1180, 1741, 0, 79, 0, 0, 1236, 1237, 86, 93, 0, 0, 1248, 1249, 98,
  99, 2532, 2484, 2484, 2484, 2484, 1707, 55, 0, 1180, 1184, 1184, 33, 33, 34, 34, 2484, 2484, 1707, 1707, 0, 0, 0, 0,
  1180, 1184, 33, 34, 2484, 1707, 2484, 2484, 2484, 2484, 1707, 0, 69, 1180, 1707, 0, 0, 0, 83, 1180, 1184, 33, 34,
  2484, 1707, 0, 0, 0, 0, 83, 0, 1180, 1184, 33, 34, 2484, 1707, 0, 0, 69, 0, 1180, 1184, 33, 41, 0, 3584, 3584, 3625,
  3584, 0, 3584, 0, 1180, 0, 0, 0, 1184, 0, 0, 2484, 0, 1707, 0, 0, 0, 0, 0, 0, 1180, 42, 0, 0, 0, 42, 0, 2176, 2176, 0,
  1180, 0, 0, 0, 1184, 0, 0, 3072, 3116, 0, 3116, 3116, 3116, 0, 1180, 0, 0, 0, 1184, 0, 0, 1707, 55, 1180, 1184, 33,
  34, 0, 0, 1792, 0, 0, 0, 0, 1792, 1792, 399, 0, 1180, 0, 413, 0, 1184, 0, 0, 3328, 3328, 0, 3328, 3328, 3328, 0, 1180,
  0, 0, 0, 1184, 0, 0, 2304, 33, 34, 0, 0, 0, 896, 1024, 768
);

(:~
 : The DFA-state to expected-token-set mapping.
 :)
declare variable $p:EXPECTED as xs:integer+ :=
(
  30, 34, 65, 38, 42, 46, 50, 62, 93, 69, 73, 78, 96, 75, 53, 56, 85, 77, 58, 85, 86, 79, 85, 86, 79, 85, 76, 80, 90,
  81, 256, 524288, 1048576, 67108864, 134217728, 32768, 524292, 67108868, 8389888, 135266564, 122884, 2370308, 83886332,
  2894596, 181408004, 181539072, 218104060, 181539076, 46395396, 180613124, 181137412, 256, 256, 256, 1280, 1280, 512,
  512, 512, 262144, 262144, 4096, 4, 1280, 1280, 1280, 1048832, 772, 134742020, 8196, 64, 128, 32, 16, 8, 4096, 131072,
  131072, 256, 1280, 512, 512, 262144, 4096, 131072, 4096, 131072, 131072, 131072, 256, 131072, 131072, 131072, 512,
  512, 264192, 264192, 262144, 262144, 262144
);

(:~
 : The token-string table.
 :)
declare variable $p:TOKEN as xs:string+ :=
(
  "(0)",
  "END",
  "S",
  "'~='",
  "'|='",
  "'^='",
  "'$='",
  "'*='",
  "IDENT",
  "STRING",
  "FUNCTION",
  "NUMBER",
  "HASH",
  "PLUS",
  "GREATER",
  "COMMA",
  "TILDE",
  "NOT",
  "DIMENSION",
  "')'",
  "'*'",
  "'-'",
  "'.'",
  "':'",
  "'='",
  "'['",
  "']'",
  "'|'"
);

(:~
 : Pass a line to fn:trace, without a generating a result. Actually,
 : create an empty result, but make it somehow dependent on trace,
 : so the optimizer does not eliminate the trace call.
 :
 : @param $line the line to be traced.
 : @return the empty sequence.
 :)
declare function p:trace($line as xs:string) as xs:string?
{
  if (trace($line, "trace")) then () else ""[.]
};

(:~
 : Match next token in input string, starting at given index, using
 : the DFA entry state for the set of tokens that are expected in
 : the current context.
 :
 : @param $input the input string.
 : @param $begin the index where to start in input string.
 : @param $token-set the expected token set id.
 : @return a sequence of three: the token code of the result token,
 : with input string begin and end positions. If there is no valid
 : token, return the negative id of the DFA state that failed, along
 : with begin and end positions of the longest viable prefix.
 :)
declare function p:match($input as xs:string,
                         $begin as xs:integer,
                         $token-set as xs:integer) as xs:integer+
{
  p:trace(concat("match tokenset=", string($token-set))),
  let $result := $p:INITIAL[1 + $token-set]
  return p:transition($input,
                      $begin,
                      $begin,
                      $begin,
                      $result,
                      $result mod 128,
                      0)
};

(:~
 : The DFA state transition function. If we are in a valid DFA state, save
 : it's result annotation, consume one input codepoint, calculate the next
 : state, and use tail recursion to do the same again. Otherwise, return
 : any valid result or a negative DFA state id in case of an error.
 :
 : @param $input the input string.
 : @param $begin the begin index of the current token in the input string.
 : @param $current the index of the current position in the input string.
 : @param $end the end index of the result in the input string.
 : @param $result the result code.
 : @param $current-state the current DFA state.
 : @param $previous-state the  previous DFA state.
 : @return a sequence of three: the token code of the result token,
 : with input string begin and end positions. If there is no valid
 : token, return the negative id of the DFA state that failed, along
 : with begin and end positions of the longest viable prefix.
 :)
declare function p:transition($input as xs:string,
                              $begin as xs:integer,
                              $current as xs:integer,
                              $end as xs:integer,
                              $result as xs:integer,
                              $current-state as xs:integer,
                              $previous-state as xs:integer) as xs:integer+
{
  if ($current-state = 0) then
    let $result := $result idiv 128
    return
      if ($result != 0) then
      (
        p:trace(concat("  done result=", $p:TOKEN[$result], " begin=", string($begin), " end=", string($end))),
        $result - 1,
        $begin,
        $end
      )
      else
      (
        p:trace(concat("  fail begin=", string($begin), " end=", string($current - 1), " state=", string($previous-state))),
        - $previous-state,
        $begin,
        $current - 1
      )
  else
    let $c0 := (string-to-codepoints(substring($input, $current, 1)), 0)[1]
    let $c1 :=
      if ($c0 < 128) then
        $p:MAP0[1 + $c0]
      else if ($c0 < 55296) then
        let $c1 := $c0 idiv 16
        let $c2 := $c1 idiv 64
        return $p:MAP1[1 + $c0 mod 16 + $p:MAP1[1 + $c1 mod 64 + $p:MAP1[1 + $c2]]]
      else
        p:map2($c0, 1, 2)
    let $current := $current + 1
    let $i0 := 128 * $c1 + $current-state - 1
    let $i1 := $i0 idiv 8
    let $next-state := $p:TRANSITION[$i0 mod 8 + $p:TRANSITION[$i1 + 1] + 1]
    return
    (
      p:trace
      (
        concat
        (
          " next state=", string($current-state),
          " offset=", string($current - 1),
          " char=", string($c0),
          " class=", string($c1),
          if ($next-state < 128) then
            ""
          else
            concat
            (
              " result=",
              $p:TOKEN[$next-state idiv 128 mod 32],
              if ($next-state < 4096) then
                ""
              else
                concat(" trailing-context-size=", string($next-state idiv 4096))
            )
        )
      ),
      if ($next-state > 127) then
        p:transition($input, $begin, $current, $current, $next-state, $next-state mod 128, $current-state)
      else
        p:transition($input, $begin, $current, $end, $result, $next-state, $current-state)
    )
};

(:~
 : Recursively translate one 32-bit chunk of an expected token bitset
 : to the corresponding sequence of token strings.
 :
 : @param $result the result of previous recursion levels.
 : @param $chunk the 32-bit chunk of the expected token bitset.
 : @param $base-token-code the token code of bit 0 in the current chunk.
 : @return the set of token strings.
 :)
declare function p:token($result as xs:string*,
                         $chunk as xs:integer,
                         $base-token-code as xs:integer) as xs:string*
{
  if ($chunk = 0) then
    $result
  else
    p:token
    (
      ($result, if ($chunk mod 2 != 0) then $p:TOKEN[$base-token-code] else ()),
      if ($chunk < 0) then $chunk idiv 2 + 2147483648 else $chunk idiv 2,
      $base-token-code + 1
    )
};

(:~
 : Calculate expected token set for a given DFA state as a sequence
 : of strings.
 :
 : @param $state the DFA state.
 : @return the set of token strings
 :)
declare function p:expected-token-set($state as xs:integer) as xs:string*
{
  if ($state > 0) then
    for $t in 0 to 0
    let $i0 := $t * 120 + $state - 1
    let $i1 := $i0 idiv 4
    return p:token((), $p:EXPECTED[$i0 mod 4 + $p:EXPECTED[$i1 + 1] + 1], $t * 32 + 1)
  else
    ()
};

(:~
 : Classify codepoint by doing a tail recursive binary search for a
 : matching codepoint range entry in MAP2, the codepoint to charclass
 : map for codepoints above the surrogate block.
 :
 : @param $c the codepoint.
 : @param $lo the binary search lower bound map index.
 : @param $hi the binary search upper bound map index.
 : @return the character class.
 :)
declare function p:map2($c as xs:integer, $lo as xs:integer, $hi as xs:integer) as xs:integer
{
  if ($lo > $hi) then
    0
  else
    let $m := ($hi + $lo) idiv 2
    return
      if ($p:MAP2[$m] > $c) then
        p:map2($c, $lo, $m - 1)
      else if ($p:MAP2[2 + $m] < $c) then
        p:map2($c, $m + 1, $hi)
      else
        $p:MAP2[4 + $m]
};

(:~
 : The index of the parser state for accessing the combined
 : (i.e. level > 1) lookahead code.
 :)
declare variable $p:lk := 1;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the token that has been shifted.
 :)
declare variable $p:b0 := 2;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the token that has been shifted.
 :)
declare variable $p:e0 := 3;

(:~
 : The index of the parser state for accessing the code of the
 : level-1-lookahead token.
 :)
declare variable $p:l1 := 4;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the level-1-lookahead token.
 :)
declare variable $p:b1 := 5;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the level-1-lookahead token.
 :)
declare variable $p:e1 := 6;

(:~
 : The index of the parser state for accessing the code of the
 : level-2-lookahead token.
 :)
declare variable $p:l2 := 7;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the level-2-lookahead token.
 :)
declare variable $p:b2 := 8;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the level-2-lookahead token.
 :)
declare variable $p:e2 := 9;

(:~
 : The index of the parser state for accessing the code of the
 : level-3-lookahead token.
 :)
declare variable $p:l3 := 10;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the begin of the level-3-lookahead token.
 :)
declare variable $p:b3 := 11;

(:~
 : The index of the parser state for accessing the position in the
 : input string of the end of the level-3-lookahead token.
 :)
declare variable $p:e3 := 12;

(:~
 : The index of the parser state for accessing the token code that
 : was expected when an error was found.
 :)
declare variable $p:error := 13;

(:~
 : The index of the parser state that points to the first entry
 : used for collecting action results.
 :)
declare variable $p:result := 14;

(:~
 : Create a textual error message from a parsing error.
 :
 : @param $input the input string.
 : @param $error the parsing error descriptor.
 : @return the error message.
 :)
declare function p:error-message($input as xs:string, $error as element(error)) as xs:string
{
  let $begin := xs:integer($error/@b)
  let $context := string-to-codepoints(substring($input, 1, $begin - 1))
  let $linefeeds := index-of($context, 10)
  let $line := count($linefeeds) + 1
  let $column := ($begin - $linefeeds[last()], $begin)[1]
  return
    if ($error/@o) then
      concat
      (
        "syntax error, found ", $p:TOKEN[$error/@o + 1], "&#10;",
        "while expecting ", $p:TOKEN[$error/@x + 1], "&#10;",
        "after scanning ", string($error/@e - $begin), " characters at line ",
        string($line), ", column ", string($column), "&#10;",
        "...", substring($input, $begin, 32), "..."
      )
    else
      let $expected := p:expected-token-set($error/@s)
      return
        concat
        (
          "lexical analysis failed&#10;",
          "while expecting ",
          "["[exists($expected[2])],
          string-join($expected, ", "),
          "]"[exists($expected[2])],
          "&#10;",
          "after scanning ", string($error/@e - $begin), " characters at line ",
          string($line), ", column ", string($column), "&#10;",
          "...", substring($input, $begin, 32), "..."
        )
};

(:~
 : Shift one token, i.e. compare lookahead token 1 with expected
 : token and in case of a match, shift lookahead tokens down such that
 : l1 becomes the current token, and higher lookahead tokens move down.
 : When lookahead token 1 does not match the expected token, raise an
 : error by saving the expected token code in the error field of the
 : parser state.
 :
 : @param $code the expected token.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:shift($code as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else if ($state[$p:l1] = $code) then
  (
    subsequence($state, $p:l1, $p:e3 - $p:l1 + 1),
    0,
    $state[$p:e3],
    subsequence($state, $p:e3),
    if ($state[$p:e0] != $state[$p:b1]) then
      text {substring($input, $state[$p:e0], $state[$p:b1] - $state[$p:e0])}
    else
      (),
    let $name := $p:TOKEN[1 + $state[$p:l1]]
    let $content := substring($input, $state[$p:b1], $state[$p:e1] - $state[$p:b1])
    return
      if (starts-with($name, "'")) then
        element TOKEN {$content}
      else
        element {$name} {$content}
  )
  else
  (
    subsequence($state, 1, $p:error - 1),
    element error
    {
      attribute b {$state[$p:b1]},
      attribute e {$state[$p:e1]},
      if ($state[$p:l1] < 0) then
        attribute s {- $state[$p:l1]}
      else
        (attribute o {$state[$p:l1]}, attribute x {$code})
    },
    subsequence($state, $p:error + 1)
  )
};

(:~
 : Lookahead one token on level 1.
 :
 : @param $set the code of the DFA entry state for the set of valid tokens.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:lookahead1($set as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:l1] != 0) then
    $state
  else
    let $match := p:match($input, $state[$p:b1], $set)
    return
    (
      $match[1],
      subsequence($state, $p:lk + 1, $p:l1 - $p:lk - 1),
      $match,
      0, $match[3], 0,
      subsequence($state, $p:e2 + 1)
    )
};

(:~
 : Lookahead one token on level 2 with whitespace skipping.
 :
 : @param $set the code of the DFA entry state for the set of valid tokens.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:lookahead2($set as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  let $match :=
    if ($state[$p:l2] != 0) then
      subsequence($state, $p:l2, $p:e2 - $p:l2 + 1)
    else
      p:match($input, $state[$p:e1], $set)
  return
  (
    $match[1] * 32 + $state[$p:l1],
    subsequence($state, $p:lk + 1, $p:l2 - $p:lk - 1),
    $match,
    0, $match[3], 0,
    subsequence($state, $p:e3 + 1)
  )
};

(:~
 : Lookahead one token on level 3 with whitespace skipping.
 :
 : @param $set the code of the DFA entry state for the set of valid tokens.
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:lookahead3($set as xs:integer, $input as xs:string, $state as item()+) as item()+
{
  let $match :=
    if ($state[$p:l3] != 0) then
      subsequence($state, $p:l3, $p:e3 - $p:l3 + 1)
    else
      p:match($input, $state[$p:e2], $set)
  return
  (
    $match[1] * 1024 + $state[$p:lk],
    subsequence($state, $p:lk + 1, $p:l3 - $p:lk - 1),
    $match,
    subsequence($state, $p:e3 + 1)
  )
};

(:~
 : Reduce the result stack. Pop $count element, wrap them in a
 : new element named $name, and push the new element.
 :
 : @param $state the parser state.
 : @param $name the name of the result node.
 : @param $count the number of child nodes.
 : @return the updated parser state.
 :)
declare function p:reduce($state as item()+, $name as xs:string, $count as xs:integer) as item()+
{
  subsequence($state, 1, $count),
  element {$name}
  {
    subsequence($state, $count + 1)
  }
};

(:~
 : Parse the 1st loop of production combinator (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(21, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-combinator-1($input, $state)
};

(:~
 : Parse the 2nd loop of production combinator (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(21, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-combinator-2($input, $state)
};

(:~
 : Parse the 3rd loop of production combinator (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator-3($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(21, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-combinator-3($input, $state)
};

(:~
 : Parse the 4th loop of production combinator (one or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator-4($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:shift(2, $input, $state)                (: S :)
    let $state := p:lookahead1(21, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        p:parse-combinator-4($input, $state)
};

(:~
 : Parse combinator.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-combinator($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state :=
    if ($state[$p:l1] = 13) then                            (: PLUS :)
      let $state := p:shift(13, $input, $state)             (: PLUS :)
      let $state := p:parse-combinator-1($input, $state)
      return $state
    else if ($state[$p:l1] = 14) then                       (: GREATER :)
      let $state := p:shift(14, $input, $state)             (: GREATER :)
      let $state := p:parse-combinator-2($input, $state)
      return $state
    else if ($state[$p:l1] = 16) then                       (: TILDE :)
      let $state := p:shift(16, $input, $state)             (: TILDE :)
      let $state := p:parse-combinator-3($input, $state)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:parse-combinator-4($input, $state)
      return $state
  return p:reduce($state, "combinator", $count)
};

(:~
 : Parse negation_arg.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-negation_arg($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state :=
    if ($state[$p:l1] = 27) then                            (: '|' :)
      let $state := p:lookahead2(9, $input, $state)         (: IDENT | '*' :)
      return $state
    else if ($state[$p:l1] = 8                              (: '*' :)
          or $state[$p:l1] = 20) then                       (: '*' :)
      let $state := p:lookahead2(11, $input, $state)        (: S | ')' | '|' :)
      let $state :=
        if ($state[$p:lk] = 872                             (: '*' '|' :)
         or $state[$p:lk] = 884) then                       (: '*' '|' :)
          let $state := p:lookahead3(9, $input, $state)     (: IDENT | '*' :)
          return $state
        else
          $state
      return $state
    else
      ($state[$p:l1], subsequence($state, $p:lk + 1))
  let $state :=
    if ($state[$p:lk] = 72                                  (: IDENT S :)
     or $state[$p:lk] = 283                                 (: '|' IDENT :)
     or $state[$p:lk] = 616                                 (: IDENT ')' :)
     or $state[$p:lk] = 9064                                (: IDENT '|' IDENT :)
     or $state[$p:lk] = 9076) then                          (: '*' '|' IDENT :)
      let $state := p:parse-type_selector($input, $state)
      return $state
    else if ($state[$p:lk] = 12) then                       (: HASH :)
      let $state := p:shift(12, $input, $state)             (: HASH :)
      return $state
    else if ($state[$p:lk] = 22) then                       (: '.' :)
      let $state := p:parse-class($input, $state)
      return $state
    else if ($state[$p:lk] = 25) then                       (: '[' :)
      let $state := p:parse-attrib($input, $state)
      return $state
    else if ($state[$p:lk] = 23) then                       (: ':' :)
      let $state := p:parse-pseudo($input, $state)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:parse-universal($input, $state)
      return $state
  return p:reduce($state, "negation_arg", $count)
};

(:~
 : Parse the 1st loop of production negation (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-negation-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(18, $input, $state)          (: S | IDENT | HASH | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-negation-1($input, $state)
};

(:~
 : Parse the 2nd loop of production negation (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-negation-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(6, $input, $state)           (: S | ')' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-negation-2($input, $state)
};

(:~
 : Parse negation.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-negation($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:shift(17, $input, $state)                 (: NOT :)
  let $state := p:parse-negation-1($input, $state)
  let $state := p:parse-negation_arg($input, $state)
  let $state := p:parse-negation-2($input, $state)
  let $state := p:shift(19, $input, $state)                 (: ')' :)
  return p:reduce($state, "negation", $count)
};

(:~
 : Parse the 2nd loop of production expression (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-expression-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(17, $input, $state)          (: S | IDENT | STRING | NUMBER | PLUS | DIMENSION | ')' |
                                                               '-' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-expression-2($input, $state)
};

(:~
 : Parse the 1st loop of production expression (one or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-expression-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state :=
      if ($state[$p:l1] = 13) then                          (: PLUS :)
        let $state := p:shift(13, $input, $state)           (: PLUS :)
        return $state
      else if ($state[$p:l1] = 21) then                     (: '-' :)
        let $state := p:shift(21, $input, $state)           (: '-' :)
        return $state
      else if ($state[$p:l1] = 18) then                     (: DIMENSION :)
        let $state := p:shift(18, $input, $state)           (: DIMENSION :)
        return $state
      else if ($state[$p:l1] = 11) then                     (: NUMBER :)
        let $state := p:shift(11, $input, $state)           (: NUMBER :)
        return $state
      else if ($state[$p:l1] = 9) then                      (: STRING :)
        let $state := p:shift(9, $input, $state)            (: STRING :)
        return $state
      else if ($state[$p:error]) then
        $state
      else
        let $state := p:shift(8, $input, $state)            (: IDENT :)
        return $state
    let $state := p:parse-expression-2($input, $state)
    return
      if ($state[$p:l1] = 19) then                          (: ')' :)
        $state
      else
        p:parse-expression-1($input, $state)
};

(:~
 : Parse expression.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-expression($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:parse-expression-1($input, $state)
  return p:reduce($state, "expression", $count)
};

(:~
 : Parse the 1st loop of production functional_pseudo (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-functional_pseudo-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(15, $input, $state)          (: S | IDENT | STRING | NUMBER | PLUS | DIMENSION | '-' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-functional_pseudo-1($input, $state)
};

(:~
 : Parse functional_pseudo.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-functional_pseudo($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:shift(10, $input, $state)                 (: FUNCTION :)
  let $state := p:parse-functional_pseudo-1($input, $state)
  let $state := p:parse-expression($input, $state)
  let $state := p:lookahead1(1, $input, $state)             (: ')' :)
  let $state := p:shift(19, $input, $state)                 (: ')' :)
  return p:reduce($state, "functional_pseudo", $count)
};

(:~
 : Parse pseudo.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-pseudo($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:shift(23, $input, $state)                 (: ':' :)
  let $state := p:lookahead1(12, $input, $state)            (: IDENT | FUNCTION | ':' :)
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:l1] = 23) then                       (: ':' :)
      let $state := p:shift(23, $input, $state)             (: ':' :)
      return $state
    else
      $state
  let $state := p:lookahead1(8, $input, $state)             (: IDENT | FUNCTION :)
  let $state :=
    if ($state[$p:l1] = 8) then                             (: IDENT :)
      let $state := p:shift(8, $input, $state)              (: IDENT :)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:parse-functional_pseudo($input, $state)
      return $state
  return p:reduce($state, "pseudo", $count)
};

(:~
 : Parse the 1st loop of production attrib (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(13, $input, $state)          (: S | IDENT | '*' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-attrib-1($input, $state)
};

(:~
 : Parse the 2nd loop of production attrib (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(16, $input, $state)          (: S | INCLUDES | DASHMATCH | PREFIXMATCH | SUFFIXMATCH |
                                                               SUBSTRINGMATCH | '=' | ']' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-attrib-2($input, $state)
};

(:~
 : Parse the 3rd loop of production attrib (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib-3($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(10, $input, $state)          (: S | IDENT | STRING :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-attrib-3($input, $state)
};

(:~
 : Parse the 4th loop of production attrib (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib-4($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(7, $input, $state)           (: S | ']' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-attrib-4($input, $state)
};

(:~
 : Parse attrib.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-attrib($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:shift(25, $input, $state)                 (: '[' :)
  let $state := p:parse-attrib-1($input, $state)
  let $state :=
    if ($state[$p:l1] = 8) then                             (: IDENT :)
      let $state := p:lookahead2(20, $input, $state)        (: S | INCLUDES | DASHMATCH | PREFIXMATCH | SUFFIXMATCH |
                                                               SUBSTRINGMATCH | '=' | ']' | '|' :)
      return $state
    else
      ($state[$p:l1], subsequence($state, $p:lk + 1))
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:lk] = 20                             (: '*' :)
          or $state[$p:lk] = 27                             (: '|' :)
          or $state[$p:lk] = 872) then                      (: IDENT '|' :)
      let $state := p:parse-namespace_prefix($input, $state)
      return $state
    else
      $state
  let $state := p:lookahead1(0, $input, $state)             (: IDENT :)
  let $state := p:shift(8, $input, $state)                  (: IDENT :)
  let $state := p:parse-attrib-2($input, $state)
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:l1] != 26) then                      (: ']' :)
      let $state :=
        if ($state[$p:l1] = 5) then                         (: PREFIXMATCH :)
          let $state := p:shift(5, $input, $state)          (: PREFIXMATCH :)
          return $state
        else if ($state[$p:l1] = 6) then                    (: SUFFIXMATCH :)
          let $state := p:shift(6, $input, $state)          (: SUFFIXMATCH :)
          return $state
        else if ($state[$p:l1] = 7) then                    (: SUBSTRINGMATCH :)
          let $state := p:shift(7, $input, $state)          (: SUBSTRINGMATCH :)
          return $state
        else if ($state[$p:l1] = 24) then                   (: '=' :)
          let $state := p:shift(24, $input, $state)         (: '=' :)
          return $state
        else if ($state[$p:l1] = 3) then                    (: INCLUDES :)
          let $state := p:shift(3, $input, $state)          (: INCLUDES :)
          return $state
        else if ($state[$p:error]) then
          $state
        else
          let $state := p:shift(4, $input, $state)          (: DASHMATCH :)
          return $state
      let $state := p:parse-attrib-3($input, $state)
      let $state :=
        if ($state[$p:l1] = 8) then                         (: IDENT :)
          let $state := p:shift(8, $input, $state)          (: IDENT :)
          return $state
        else if ($state[$p:error]) then
          $state
        else
          let $state := p:shift(9, $input, $state)          (: STRING :)
          return $state
      let $state := p:parse-attrib-4($input, $state)
      return $state
    else
      $state
  let $state := p:lookahead1(3, $input, $state)             (: ']' :)
  let $state := p:shift(26, $input, $state)                 (: ']' :)
  return p:reduce($state, "attrib", $count)
};

(:~
 : Parse class.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-class($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:shift(22, $input, $state)                 (: '.' :)
  let $state := p:lookahead1(0, $input, $state)             (: IDENT :)
  let $state := p:shift(8, $input, $state)                  (: IDENT :)
  return p:reduce($state, "class", $count)
};

(:~
 : Parse universal.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-universal($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state :=
    if ($state[$p:l1] = 20) then                            (: '*' :)
      let $state := p:lookahead2(24, $input, $state)        (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               ')' | '.' | ':' | '[' | '|' :)
      return $state
    else
      ($state[$p:l1], subsequence($state, $p:lk + 1))
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:lk] = 8                              (: IDENT :)
          or $state[$p:lk] = 27                             (: '|' :)
          or $state[$p:lk] = 884) then                      (: '*' '|' :)
      let $state := p:parse-namespace_prefix($input, $state)
      return $state
    else
      $state
  let $state := p:lookahead1(2, $input, $state)             (: '*' :)
  let $state := p:shift(20, $input, $state)                 (: '*' :)
  return p:reduce($state, "universal", $count)
};

(:~
 : Parse element_name.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-element_name($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:shift(8, $input, $state)                  (: IDENT :)
  return p:reduce($state, "element_name", $count)
};

(:~
 : Parse namespace_prefix.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-namespace_prefix($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:l1] != 27) then                      (: '|' :)
      let $state :=
        if ($state[$p:l1] = 8) then                         (: IDENT :)
          let $state := p:shift(8, $input, $state)          (: IDENT :)
          return $state
        else if ($state[$p:error]) then
          $state
        else
          let $state := p:shift(20, $input, $state)         (: '*' :)
          return $state
      return $state
    else
      $state
  let $state := p:lookahead1(4, $input, $state)             (: '|' :)
  let $state := p:shift(27, $input, $state)                 (: '|' :)
  return p:reduce($state, "namespace_prefix", $count)
};

(:~
 : Parse type_selector.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-type_selector($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state :=
    if ($state[$p:l1] = 8) then                             (: IDENT :)
      let $state := p:lookahead2(24, $input, $state)        (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               ')' | '.' | ':' | '[' | '|' :)
      return $state
    else
      ($state[$p:l1], subsequence($state, $p:lk + 1))
  let $state :=
    if ($state[$p:error]) then
      $state
    else if ($state[$p:lk] = 20                             (: '*' :)
          or $state[$p:lk] = 27                             (: '|' :)
          or $state[$p:lk] = 872) then                      (: IDENT '|' :)
      let $state := p:parse-namespace_prefix($input, $state)
      return $state
    else
      $state
  let $state := p:lookahead1(0, $input, $state)             (: IDENT :)
  let $state := p:parse-element_name($input, $state)
  return p:reduce($state, "type_selector", $count)
};

(:~
 : Parse the 1st loop of production simple_selector_sequence (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-simple_selector_sequence-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(22, $input, $state)          (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               '.' | ':' | '[' :)
    return
      if ($state[$p:l1] != 12                               (: HASH :)
      and $state[$p:l1] != 17                               (: NOT :)
      and $state[$p:l1] != 22                               (: '.' :)
      and $state[$p:l1] != 23                               (: ':' :)
      and $state[$p:l1] != 25) then                         (: '[' :)
        $state
      else
        let $state :=
          if ($state[$p:l1] = 12) then                      (: HASH :)
            let $state := p:shift(12, $input, $state)       (: HASH :)
            return $state
          else if ($state[$p:l1] = 22) then                 (: '.' :)
            let $state := p:parse-class($input, $state)
            return $state
          else if ($state[$p:l1] = 25) then                 (: '[' :)
            let $state := p:parse-attrib($input, $state)
            return $state
          else if ($state[$p:l1] = 23) then                 (: ':' :)
            let $state := p:parse-pseudo($input, $state)
            return $state
          else if ($state[$p:error]) then
            $state
          else
            let $state := p:parse-negation($input, $state)
            return $state
        return p:parse-simple_selector_sequence-1($input, $state)
};

(:~
 : Parse the 2nd loop of production simple_selector_sequence (one or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-simple_selector_sequence-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state :=
      if ($state[$p:l1] = 12) then                          (: HASH :)
        let $state := p:shift(12, $input, $state)           (: HASH :)
        return $state
      else if ($state[$p:l1] = 22) then                     (: '.' :)
        let $state := p:parse-class($input, $state)
        return $state
      else if ($state[$p:l1] = 25) then                     (: '[' :)
        let $state := p:parse-attrib($input, $state)
        return $state
      else if ($state[$p:l1] = 23) then                     (: ':' :)
        let $state := p:parse-pseudo($input, $state)
        return $state
      else if ($state[$p:error]) then
        $state
      else
        let $state := p:parse-negation($input, $state)
        return $state
    let $state := p:lookahead1(22, $input, $state)          (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               '.' | ':' | '[' :)
    return
      if ($state[$p:l1] != 12                               (: HASH :)
      and $state[$p:l1] != 17                               (: NOT :)
      and $state[$p:l1] != 22                               (: '.' :)
      and $state[$p:l1] != 23                               (: ':' :)
      and $state[$p:l1] != 25) then                         (: '[' :)
        $state
      else
        p:parse-simple_selector_sequence-2($input, $state)
};

(:~
 : Parse simple_selector_sequence.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-simple_selector_sequence($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:lookahead1(19, $input, $state)            (: IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
  let $state :=
    if ($state[$p:l1] = 8                                   (: IDENT :)
     or $state[$p:l1] = 20                                  (: '*' :)
     or $state[$p:l1] = 27) then                            (: '|' :)
      let $state :=
        if ($state[$p:l1] = 27) then                        (: '|' :)
          let $state := p:lookahead2(9, $input, $state)     (: IDENT | '*' :)
          return $state
        else if ($state[$p:l1] = 8                          (: '*' :)
              or $state[$p:l1] = 20) then                   (: '*' :)
          let $state := p:lookahead2(23, $input, $state)    (: END | S | HASH | PLUS | GREATER | COMMA | TILDE | NOT |
                                                               '.' | ':' | '[' | '|' :)
          let $state :=
            if ($state[$p:lk] = 872                         (: '*' '|' :)
             or $state[$p:lk] = 884) then                   (: '*' '|' :)
              let $state := p:lookahead3(9, $input, $state) (: IDENT | '*' :)
              return $state
            else
              $state
          return $state
        else
          ($state[$p:l1], subsequence($state, $p:lk + 1))
      let $state :=
        if ($state[$p:lk] = 40                              (: IDENT END :)
         or $state[$p:lk] = 72                              (: IDENT S :)
         or $state[$p:lk] = 283                             (: '|' IDENT :)
         or $state[$p:lk] = 392                             (: IDENT HASH :)
         or $state[$p:lk] = 424                             (: IDENT PLUS :)
         or $state[$p:lk] = 456                             (: IDENT GREATER :)
         or $state[$p:lk] = 488                             (: IDENT COMMA :)
         or $state[$p:lk] = 520                             (: IDENT TILDE :)
         or $state[$p:lk] = 552                             (: IDENT NOT :)
         or $state[$p:lk] = 712                             (: IDENT '.' :)
         or $state[$p:lk] = 744                             (: IDENT ':' :)
         or $state[$p:lk] = 808                             (: IDENT '[' :)
         or $state[$p:lk] = 9064                            (: IDENT '|' IDENT :)
         or $state[$p:lk] = 9076) then                      (: '*' '|' IDENT :)
          let $state := p:parse-type_selector($input, $state)
          return $state
        else if ($state[$p:error]) then
          $state
        else
          let $state := p:parse-universal($input, $state)
          return $state
      let $state := p:parse-simple_selector_sequence-1($input, $state)
      return $state
    else if ($state[$p:error]) then
      $state
    else
      let $state := p:parse-simple_selector_sequence-2($input, $state)
      return $state
  return p:reduce($state, "simple_selector_sequence", $count)
};

(:~
 : Parse the 1st loop of production selector (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selector-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(14, $input, $state)          (: END | S | PLUS | GREATER | COMMA | TILDE :)
    return
      if ($state[$p:l1] = 1                                 (: END :)
       or $state[$p:l1] = 15) then                          (: COMMA :)
        $state
      else
        let $state := p:parse-combinator($input, $state)
        let $state := p:parse-simple_selector_sequence($input, $state)
        return p:parse-selector-1($input, $state)
};

(:~
 : Parse selector.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selector($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:parse-simple_selector_sequence($input, $state)
  let $state := p:parse-selector-1($input, $state)
  return p:reduce($state, "selector", $count)
};

(:~
 : Parse the 2nd loop of production selectors_group (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selectors_group-2($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(21, $input, $state)          (: S | IDENT | HASH | NOT | '*' | '.' | ':' | '[' | '|' :)
    return
      if ($state[$p:l1] != 2) then                          (: S :)
        $state
      else
        let $state := p:shift(2, $input, $state)            (: S :)
        return p:parse-selectors_group-2($input, $state)
};

(:~
 : Parse the 1st loop of production selectors_group (zero or more). Use
 : tail recursion for iteratively updating the parser state.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selectors_group-1($input as xs:string, $state as item()+) as item()+
{
  if ($state[$p:error]) then
    $state
  else
    let $state := p:lookahead1(5, $input, $state)           (: END | COMMA :)
    return
      if ($state[$p:l1] != 15) then                         (: COMMA :)
        $state
      else
        let $state := p:shift(15, $input, $state)           (: COMMA :)
        let $state := p:parse-selectors_group-2($input, $state)
        let $state := p:parse-selector($input, $state)
        return p:parse-selectors_group-1($input, $state)
};

(:~
 : Parse selectors_group.
 :
 : @param $input the input string.
 : @param $state the parser state.
 : @return the updated parser state.
 :)
declare function p:parse-selectors_group($input as xs:string, $state as item()+) as item()+
{
  let $count := count($state)
  let $state := p:parse-selector($input, $state)
  let $state := p:parse-selectors_group-1($input, $state)
  return p:reduce($state, "selectors_group", $count)
};

(:~
 : Parse start symbol selectors_group from given string.
 :
 : @param $s the string to be parsed.
 : @return the result as generated by parser actions.
 :)
declare function p:parse-selectors_group($s as xs:string) as item()*
{
  let $state := p:parse-selectors_group($s, (0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, false()))
  let $error := $state[$p:error]
  return
    if ($error) then
      element ERROR {$error/@*, p:error-message($s, $error)}
    else
      subsequence($state, $p:result)
};
declare function p:parse($s as xs:string) as item()* {
    p:parse-selectors_group($s)
};
(: End :)
