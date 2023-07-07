---
title: Leetcode第704题 二分查找
tags:
    - Leetcode
categories:
    - 算法
date: 2022-07-01 12:01:01
thumbnail:
---
# Leetcode第704题 - 二分查找

## 🌟 题目描述

给定一个 n 个元素有序的（升序）整型数组 nums 和一个目标值 target  ，写一个函数搜索 nums 中的 target，如果目标值存在返回下标，否则返回 -1。

**示例 1:**

```
输入: nums = [-1,0,3,5,9,12], target = 9
输出: 4
解释: 9 出现在 nums 中并且下标为 4
```

**示例 2:**

```
输入: nums = [-1,0,3,5,9,12], target = 2
输出: -1
解释: 2 不存在 nums 中因此返回 -1
```

**提示：**

1. 你可以假设 nums 中的所有元素是不重复的。
2. n 将在 [1, 10000]之间。
3. nums 的每个元素都将在 [-9999, 9999]之间。

## 🐂 解题方法

### 1⃣️ 方法一：二分查找

<code-group>
  <code-block title="JAVA 二分查找" active>

  ```java
class Solution {
    public int search(int[] nums, int target) {
        int left = 0;
        int right = nums.length-1;
        while(left <= right ) {
            int mi = left + (right-left) /2;
            if (nums[mi]== target) {
                return mi;
            } else if (nums[mi] > target)  {
                right = mi-1;
            } else if (nums[mi] < target)  {
                left = mi+1;
            } 
        }
        return -1;
    }
}
  ```

</code-block>
</code-group>

<img src="https://file.pandacode.cn/blog/202202101646480.png" alt="image-20220127115747828" style="zoom:50%;" />

## 🙏 感谢

- [力扣（LeetCode）](https://leetcode-cn.com/)
