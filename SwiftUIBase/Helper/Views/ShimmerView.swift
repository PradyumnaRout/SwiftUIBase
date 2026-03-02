//
//  ShimmerView.swift
//  SwiftUIBase
//
//  Created by hb on 02/03/26.
//

import SwiftUI

protocol ShimmerableModel: Identifiable, Hashable {
    var ID: AnyHashable { get }
    static func shimmerPlaceholders(count: Int) -> [Self]
}


struct ContentStateView<Item: ShimmerableModel, Content: View>: View {
    let items: [Item]
    let isLoading: Bool
    let isEmpty: Bool
    let initialShimmerCount: Int
    let paginationShimmerCount: Int
    let emptyMessage: String
    @ViewBuilder let content: (Item, Int?) -> Content
    
    init(
        items: [Item],
        isLoading: Bool,
        isEmpty: Bool = false,
        initialShimmerCount: Int = 5,
        paginationShimmerCount: Int = 3,
        emptyMessage: String = "No items found",
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.isLoading = isLoading
        self.isEmpty = isEmpty
        self.initialShimmerCount = initialShimmerCount
        self.paginationShimmerCount = paginationShimmerCount
        self.emptyMessage = emptyMessage
        self.content = { item, _ in content(item) }
    }
    
    init(
        items: [Item],
        isLoading: Bool,
        isEmpty: Bool = false,
        initialShimmerCount: Int = 5,
        paginationShimmerCount: Int = 3,
        emptyMessage: String = "No items found",
        @ViewBuilder content: @escaping (Item, Int) -> Content
    ) {
        self.items = items
        self.isLoading = isLoading
        self.isEmpty = isEmpty
        self.initialShimmerCount = initialShimmerCount
        self.paginationShimmerCount = paginationShimmerCount
        self.emptyMessage = emptyMessage
        self.content = { item, index in content(item, index ?? 0) }
    }
    
    init(
        item: Item?,
        isLoading: Bool,
        emptyMessage: String = "No items found",
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = item.map { [$0] } ?? []
        self.isLoading = isLoading
        self.isEmpty = item == nil && !isLoading
        self.initialShimmerCount = 1
        self.paginationShimmerCount = 0
        self.emptyMessage = emptyMessage
        self.content = { item, _ in content(item) }
    }
    
    var body: some View {
        Group {
            if isLoading && items.isEmpty {
                ForEach(Item.shimmerPlaceholders(count: initialShimmerCount)) { item in
                    content(item, nil)
                        .shimmer(when: .constant(true))
                        .allowsHitTesting(false)
                }
            } else {
                ForEach(Array(items.enumerated()), id: \.element.ID) { index, item in
                    content(item, index)
                }
                
                if items.isEmpty && !isLoading && isEmpty {
                    Text(emptyMessage)
                        .foregroundStyle(.gray)
                        .padding(.top, -40)
                        .frame(maxWidth: .infinity)
                        .containerRelativeFrame(.vertical)

                }
                
                if isLoading && !items.isEmpty {
                    ForEach(Item.shimmerPlaceholders(count: paginationShimmerCount)) { item in
                        content(item, nil)
                            .shimmer(when: .constant(true))
                    }
                }
            }
        }
    }
}

