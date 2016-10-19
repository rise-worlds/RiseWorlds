#include <stdio.h>
#include <iostream>
#include <algorithm>
#include <string>
#include <iomanip>

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef unsigned long long uint64;
typedef char int8;
typedef short int16;
typedef int int32;
typedef long long int64;

struct RankLevleItem
{
	uint64 id;
	uint16 sex;
	std::string name;
	std::string faction;
	uint32 level;
	uint64 exp;
	uint32 time;			//数据最后更新时间
	static bool cmp(RankLevleItem& left, RankLevleItem& right)
	{
		if (left.level == right.level)
			if (left.exp == right.exp)
				return left.time < right.time;		//升序
			else
				return left.exp > right.exp;		//降序
		return left.level > right.level;			//降序
	}
	bool operator < (RankLevleItem const &it)
	{
		if (this->level == it.level)
			if (this->exp == it.exp)
				return this->time < it.time;		//升序
			else
				return this->exp > it.exp;			//降序
		return this->level > it.level;				//降序
	}
};
RankLevleItem list[6] = {
	  { 1, 1, "a", "", 10, 1000, 10 }
	, { 2, 2, "b", "", 10, 1000, 20 }
	, { 3, 1, "c", "", 15, 1560, 30 }
	, { 4, 1, "d", "", 20, 2030, 35 }
	, { 5, 2, "e", "",  9,  930, 25 }
	, { 6, 2, "f", "", 50, 5023, 80 }
};

int main()
{
	const int RANK_PAGE_COUNT = 10;
	const int RANK_PAGE_ITEM_COUNT = 10;
	const int RANK_ITEM_TOTAL_COUNT = RANK_PAGE_COUNT * RANK_PAGE_ITEM_COUNT;
	
	uint8 cur_page = 1;
	int64 count = 0xFFFF;
	if (count > RANK_ITEM_TOTAL_COUNT) count = RANK_ITEM_TOTAL_COUNT;
	uint8 total = (uint8)((count + RANK_PAGE_COUNT - 1) / RANK_PAGE_COUNT);
	if (cur_page > total) cur_page = total;
	int start_rank = (cur_page - 1) * RANK_PAGE_ITEM_COUNT;
	int end_rank = cur_page * RANK_PAGE_ITEM_COUNT;

	printf("%d %d %d %d\n", cur_page, total, start_rank, end_rank);

	std::cout << "sort before" << std::endl;
	for (auto item : list)
	{
		//std::cout << std::setw(10) << std::setiosflags(std::ios::left);
		std::cout << item.id << "\t" << item.name << "\t" << item.sex
			<< "\t" << item.level << "\t" << item.exp << "\t" << item.time << std::endl;
	}

	std::sort(list, list + 6);
	//std::sort(list, list + 6, RankLevleItem::cmp);
	std::cout << "sort after" << std::endl;
	for (auto item : list)
	{
		//std::cout << std::setw(10) << std::setiosflags(std::ios::left);
		std::cout << item.id << "\t" << item.name << "\t" << item.sex
			<< "\t" << item.level << "\t" << item.exp << "\t" << item.time << std::endl;
	}

	return 0;
}