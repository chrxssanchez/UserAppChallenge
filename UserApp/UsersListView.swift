// UsersListView.swift

import SwiftUI

struct UsersListView: View {
    @State private var viewModel = UsersViewModel(apiClient: UsersAPIClient())

    var body: some View {
        NavigationStack {
            List{
                content
            }
            .refreshable {
                await viewModel.load()
            }
                .navigationTitle("Users")
                .toolbar {
                    Button("Refresh") {
                        Task {
                            await viewModel.load()
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
                .task {
                    await viewModel.load()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading…")
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)

        case .failed(let errorMessage):
            VStack(spacing: 8) {
                Text("Something went wrong")
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Try Again") {
                    Task {
                        await viewModel.load()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)

        case .loaded(let users):
            ForEach(users) { user in
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                    Text(user.company.name)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
