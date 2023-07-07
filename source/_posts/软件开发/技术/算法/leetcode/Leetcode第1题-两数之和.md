---
title: Leetcode第1题 两数之和
tags:
  - Leetcode
categories:
  - 算法
date: 2022-07-01 12:01:01
thumbnail:
---

## 🌟题目描述

给定一个整数数组 `nums` 和一个整数目标值 `target`，请你在该数组中找出 **和为目标值** `target`  的那 **两个** 整数，并返回它们的数组下标。

你可以假设每种输入只会对应一个答案。但是，数组中同一个元素在答案里不能重复出现。

你可以按任意顺序返回答案。

**示例 1：**

```
输入：nums = [2,7,11,15], target = 9
输出：[0,1]
解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。
```

**示例 2：**

```
输入：nums = [3,2,4], target = 6
输出：[1,2]
```

**示例 3：**

```
输入：nums = [3,3], target = 6
输出：[0,1]
```

**提示：**

- `2 <= nums.length <= 104`

- `-109 <= nums[i] <= 109`

- `-109 <= target <= 109`

- 只会存在一个有效答案

  

  **进阶**：你可以想出一个时间复杂度小于 O(n2) 的算法吗？

## 🐂 解题方法

### 1⃣️ 方法一：

<code-group>
  <code-block title="JAVA" active>

  ```java
class Solution {
    public int[] twoSum(int[] nums, int target) {
        HashMap<Integer, Integer> map = new HashMap<>();
        for(int i = 0 ; i <= nums.length; i++) {
            if (map.containsKey(target - nums[i])) {
                return new int[]{map.get(target - nums[i]), i};
            }
            map.put(nums[i], i);
        }
        return new int[]{};
    }
}
  ```

</code-block>
</code-group>

<img src="https://file.pandacode.cn/blog/202202101640549.png" alt="image-20220127151855954" style="zoom:50%;" />

## 🙏 感谢

- [力扣（LeetCode）](https://leetcode-cn.com/)
