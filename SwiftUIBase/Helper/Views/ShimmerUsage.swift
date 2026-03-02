//
//  ShimmerUsage.swift
//  SwiftUIBase
//
//  Created by hb on 02/03/26.
//

import Foundation

//MARK: Shimmer Usage -
// For Single object
/*
 ScrollView {
     VStack(spacing: 40) {
         ContentStateView(
             item: vm.campaignDetail,
             isLoading: vm.isLoading) { _ in
                 TopBannerView()
                 CampaignInfoView()
                 AboutCampaignView()
                 if !vm.howItWorks.isEmpty {
                     HowItWorksView()
                 }
                 if !vm.keyHightlights.isEmpty {
                     KeyHiglightsView()
                 }
                 if !vm.eligibleNotes.isEmpty {
                     EligibilityView()
                 }
                 if !isJoined {
                     joinNowBtn()
                 }
             }
     }
     .padding(.horizontal)
 }
 */

// for forEach
/*
 private var contentView: some View {
     ScrollView(.vertical) {
         LazyVStack(spacing: 15) {
             // Generic COntentStateView
             ContentStateView(
                 items: vm.items,
                 isLoading: vm.isLoading,
                 isEmpty: true,
                 emptyMessage: "No Offer found") { offer in
                     OfferRow(offer: offer)
                         .onTapGesture {
                             vm.navigateToOfferDetail(id: offer.id ?? "")
                         }
                         .onAppear {
                             vm.loadNextIfNeeded(offer)
                         }
                 }
         }
         .padding()
         .padding(.top)
         .padding(.top, 35)
     }
     .scrollIndicators(.hidden)
     .scrollDisabled(vm.items.isEmpty)
     .scrollBounceBehavior(.basedOnSize)
 }
 
 
 OR
 
 
 private var dataContent: some View {
     LazyVGrid(
         columns: vm.selectedTab == .product ? productColumns  : voucherColumns,
         alignment: .center,
         spacing: vm.selectedTab == .product ? 10  : 15,
         pinnedViews: .sectionHeaders
     ) {
         Section {
             switch vm.selectedTab {
             case .product:
                 ContentStateView(
                     items: vm.products,
                     isLoading: vm.isLoading(.product),
                     isEmpty: true,
                     emptyMessage: "No product found") {
                         product,
                         index in
                         ProductCell(
                             item: product,
                             isInCart: product.isInCart,
                             detailHandler: {
                                 vm.currentProductIndex = index
                                 showDetailPage.toggle()
                             },
                             onRedeem: { isRedeemable in
                                 if isRedeemable {
                                     if product.isInCart {
                                         GlobalUtility.shared.showAlert(body: "Already added in Cart.")
                                     } else {
                                         if let description = product.description, description.count > 0 {
                                             vm.currentProductIndex = index
                                             showDetailPage.toggle()
                                         } else {
                                             CacheManager.shared.addToCart(product)
                                             router.push(AnyScreen(
                                                 CartView(vm: CartViewModel(router: router))
                                             ))
                                         }
                                     }
                                 } else {
                                     nonRedeemableSheetData = .init(requiredDrops: product.requiredDrops)
                                 }
                             })
                         .onAppear {
                             // Only trigger for the last few cells
                             if index == vm.products.count - 3 {
                                 vm.loadMoreData(type: .product)
                             }
                         }
                     }
             case .voucher:
                 ContentStateView(
                     items: vm.vouchers,
                     isLoading: vm.isLoading(.voucher),
                     isEmpty: true,
                     emptyMessage: "No Voucher found") { voucher, index in
                         VoucherCell(
                             item: voucher,
                             onRedeem: { isRedeemable in
                                 if isRedeemable {
                                     vm.redeemVoucher(id: voucher.identifier ?? "")
                                 } else {
                                     nonRedeemableSheetData = .init(requiredDrops: voucher.requiredDrops)
                                 }
                             }, detailHandler: {
                                 vm.currentVoucherIndex = index
                                 showDetailPage.toggle()
                             })
                         .onAppear {
                             if index >= vm.vouchers.count - 3 {
                                vm.loadMoreData(type: .voucher)
                             }
                         }
                     }
             }
         } header: {
             EmptyView()
                 .frame(height: 0)
         }
     }
     .id("\(vm.selectedTab)-\(vm.updateTrigger)")
     .padding(.horizontal)
 }
 */



// Direct use of shimmer modifier
/*
 ScrollView(.vertical, showsIndicators: false) {
     VStack(alignment: .leading, spacing: 30) {
         // SweepStakes (Can be hidden)
         sweepStakeView
             .padding()
         
         // Offers
         offerView
         
         happyBearView
         
         latestNewsView
         
         if let recentActivities = viewModel.homeData?.recentActivity, recentActivities.count > 0 {
             recentActivityView(recentActivities)
         }
     }
     .padding(.top, 20)
     .padding(.bottom, 116)
     .shimmer(when: $vm.isLoading)
 }
 */
