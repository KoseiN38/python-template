FROM python:3.12-slim

# 必要なツールのインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Poetry のインストール
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

# 作業ディレクトリの設定
WORKDIR /app

# 仮想環境フォルダーの作成
RUN mkdir /app/.venv

# プロジェクトファイルのコピー
COPY . /app/

# Poetry の設定と依存関係のインストール
RUN poetry config virtualenvs.in-project true \
    && python3 -m venv /app/.venv \
    && . /app/.venv/bin/activate \
    && poetry install --no-root --no-interaction

# 環境変数の設定
ENV PYTHONPATH=/app
ENV PATH="/app/.venv/bin:$PATH"

# コンテナ起動時のデフォルトコマンド
CMD ["bash"]

