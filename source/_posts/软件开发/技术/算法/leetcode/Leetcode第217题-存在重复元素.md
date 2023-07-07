---
title: Leetcode第217题 存在重复元素
tags:
    - Leetcode
categories:
    - 算法
date: 2022-07-01 12:01:01
thumbnail:
---

## 🌟 题目描述

给你一个整数数组 nums 。如果任一值在数组中出现 至少两次 ，返回 true ；如果数组中每个元素互不相同，返回 false 。

**示例 1：**

```
输入：nums = [1,2,3,1]
输出：true
```

**示例 2：**

```
输入：nums = [1,2,3,4]
输出：false
```

**示例 3：**

```
输入：nums = [1,1,1,3,3,4,3,2,4,2]
输出：true
```


提示：

- 1 <= nums.length <= 105
- -109 <= nums[i] <= 109

## 🐂 解题方法

### 1⃣️ 方法一：哈希表

对于数组中每个元素，我们将它插入到哈希表中。如果插入一个元素时发现该元素已经存在于哈希表中，则说明存在重复的元素。

<code-group>
  <code-block title="JAVA" active>

  ```java
class Solution {
    public boolean containsDuplicate(int[] nums) {
        Set<Integer> datas = new HashSet<Integer>();
        for(int i = 0; i < nums.length ; i++) {
            if (!datas.add(nums[i])){
                return true;
            }
        }
        return false;
    }
}
  ```

</code-block>
</code-group>

<img src="https://file.pandacode.cn/blog/202201271143358.png" alt="image-20220127114324756" style="zoom:50%;" />

**复杂度分析**

- 时间复杂度：O(N)，其中 N 为数组的长度。
- 空间复杂度：O(N)，其中 N 为数组的长度。

## 🙏 感谢

- [力扣（LeetCode）](https://leetcode-cn.com/)
